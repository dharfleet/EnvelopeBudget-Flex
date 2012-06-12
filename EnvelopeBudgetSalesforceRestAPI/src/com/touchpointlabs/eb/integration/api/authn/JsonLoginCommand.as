/**
 Copyright © 2012 Daniel Harfleet. All Rights Reserved.

  Redistribution and use in source and binary forms, with or without modification, are
  permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list
  of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright notice, this
  list of conditions and the following disclaimer in the documentation and/or other
  materials provided with the distribution.

  3. The name of the author may not be used to endorse or promote products derived from
  this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY The Copyright Holder "AS IS" AND ANY EXPRESS OR IMPLIED
  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
  AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package com.touchpointlabs.eb.integration.api.authn
{
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;

	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;


	public class JsonLoginCommand implements LoginCommand
	{
		public function JsonLoginCommand(organization : SalesforceOrg, httpService : HTTPService, logFactory : LogFactory)
		{
			this.organization = organization;
			this.httpService = httpService;
			this.log = logFactory.getLogger(JsonLoginCommand);
			prepareHttpService();
		}


		public function execute(callback : Function, credentials : UserCredentials) : void
		{
			this._callback = callback;

			if (isLoggedIntoOrganization(credentials, organization))
			{
				log.debug("is already logged in, shortcutting");

				_callback(organization);
			}
			else
			{
				log.debug("is not already logged in, will do now");

				addListeners();

				var params : Object = prepareHttpParams(credentials);

				log.prettyPrintObjectIfDebugEnabled(params, "http params");
				log.debug("sending");

				httpService.send(params);
			}
		}


		protected function handleResult(resultEvent : ResultEvent) : void
		{
			removeListeners();

			var httpResponse : String = String(resultEvent.result);
			log.prettyPrintObjectIfDebugEnabled(httpResponse, "http response");

			var jsonResponse : Object = JSON.parse(httpResponse);
			log.prettyPrintObjectIfDebugEnabled(jsonResponse, "json response");

			organization.accessToken = jsonResponse.access_token;
			organization.url = jsonResponse.instance_url;

			_callback(organization);
		}


		protected function isLoggedIntoOrganization(credentials : UserCredentials, organization : SalesforceOrg) : Boolean
		{
			return organization.accessToken != null;
		}


		protected function handleFault(faultEvent : FaultEvent) : void
		{
			log.error("findAll, an error occured: {0}", faultEvent.message);
			log.prettyPrintObjectIfDebugEnabled(faultEvent.fault);
			removeListeners();
			_callback(faultEvent);
		}


		protected function addListeners() : void
		{
			httpService.addEventListener(ResultEvent.RESULT, handleResult);
			httpService.addEventListener(FaultEvent.FAULT, handleFault);
		}


		protected function removeListeners() : void
		{
			httpService.removeEventListener(ResultEvent.RESULT, handleResult);
			httpService.removeEventListener(FaultEvent.FAULT, handleFault);
		}


		private function prepareHttpService() : void
		{
			this.httpService.url = URL;
			this.httpService.method = HTTP_POST;
			this.httpService.resultFormat = RESULT_FORMAT_TEXT;
			this.httpService.headers[ACCEPT_TYPE_KEY] = ACCEPT_TYPE_VALUE;
		}


		private function prepareHttpParams(credentials : UserCredentials) : Object
		{
			var params : Object = new Object();
			params.grant_type = GRANT_TYPE_PASSWORD;
			params.client_id = organization.consumerKey;
			params.client_secret = organization.consumerSecret;
			params.username = credentials.username;
			params.password = credentials.fullPassword;
			return params;
		}


		private var httpService : HTTPService;
		private var credentials : UserCredentials;
		private var organization : SalesforceOrg;
		private var _callback : Function;

		private var log : Logger;

		private static const URL : String = "https://login.salesforce.com/services/oauth2/token"; // TODO (Future) - this should probably be moved to config
		private static const HTTP_POST : String = "POST";
		private static const RESULT_FORMAT_TEXT : String = "text";
		private static const GRANT_TYPE_PASSWORD : String = "password";
		private static const ACCEPT_TYPE_KEY : String = "Accept";
		private static const ACCEPT_TYPE_VALUE : String = "application/json"
	}
}
