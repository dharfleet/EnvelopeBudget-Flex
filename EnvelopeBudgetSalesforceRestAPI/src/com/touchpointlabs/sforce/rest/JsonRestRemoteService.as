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
package com.touchpointlabs.sforce.rest
{

	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import flash.events.EventDispatcher;

	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.StringUtil;


	public class JsonRestRemoteService extends EventDispatcher implements RestRemoteService
	{

		public function JsonRestRemoteService(httpService : HTTPService, apiVersion : String, logFactory : LogFactory)
		{
			this.http = httpService;
			this.http.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			this.http.contentType = CONTENT_TYPE_JSON;
			this.apiVersion = apiVersion;
			this.url = "/services/data/{0}/";

			this.log = logFactory.getLogger(JsonRestRemoteService);
		}


		public function setAccessToken(accessToken : String) : void
		{
			addHeader("authorization", StringUtil.substitute("OAuth {0}", accessToken));
		}


		public function setOrgInstanceUrl(url : String) : void
		{
			this.instanceUrl = url;
		}


		public function addHeader(key : String, value : Object) : void
		{
			log.debug("addHeader, key={0}, value={1}", key, value);
			http.headers[key] = value;
		}


		public function addParameter(key : String, value : Object) : void
		{
			log.debug("addParameter, key={0}, value={1}", key, value);
			http.request[key] = value;
		}


		public function setJsonParameter(jsonRecord : Object) : void
		{
			log.debug("setJsonParameter, {0}", jsonRecord);
			http.request = jsonRecord;
		}


		public function addJsonResultListener(listener : Function) : void
		{
			addEventListener(JsonResultEvent.RESULT, listener);
		}


		public function removeJsonResultListener(listener : Function) : void
		{
			removeEventListener(JsonResultEvent.RESULT, listener);
		}


		public function call() : void
		{
			addInternalListeners();
			addHeader(ACCEPT_TYPE_KEY, ACCEPT_TYPE_VALUE);
			http.url = instanceUrl + StringUtil.substitute(url, apiVersion);
			log.debug("call");
			logHttp(http);
			http.send();
		}


		public function appendToUrl(text : String) : void
		{
			url += text;
		}


		private function logHttp(http : HTTPService) : void
		{
			log.debug("method", http.method);
			log.debug("url", http.url);
			log.prettyPrintObjectIfDebugEnabled(http.headers, "headers");
			log.prettyPrintObjectIfDebugEnabled(http.request);
		}


		private function onResult(event : ResultEvent) : void
		{
			removeInternalListeners();

			var httpResponse : String = String(event.result);
			log.debug("http response", httpResponse);

			var jsonResponse : Object = JSON.parse(httpResponse);

			var resultEvent : JsonResultEvent = new JsonResultEvent(jsonResponse);

			dispatchEvent(resultEvent);
		}


		private function onFault(event : FaultEvent) : void
		{
			removeInternalListeners();
			log.warn("error {0}", event.message);
			log.prettyPrintObjectIfDebugEnabled(event.fault);
			dispatchEvent(event);
		}


		private function initializeHttpService() : void
		{
			http.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			http.contentType = CONTENT_TYPE_JSON;
		}


		private function addInternalListeners() : void
		{
			http.addEventListener(ResultEvent.RESULT, onResult);
			http.addEventListener(FaultEvent.FAULT, onFault);
		}


		private function removeInternalListeners() : void
		{
			http.removeEventListener(ResultEvent.RESULT, onResult);
			http.removeEventListener(FaultEvent.FAULT, onFault);
		}


		private var http : HTTPService;
		private var apiVersion : String;
		private var instanceUrl : String;
		private var url : String;

		private var log : Logger;

		private static const CONTENT_TYPE_JSON : String = "application/json"
		private static const ACCEPT_TYPE_KEY : String = "Accept";
		private static const ACCEPT_TYPE_VALUE : String = "application/json"
	}
}
