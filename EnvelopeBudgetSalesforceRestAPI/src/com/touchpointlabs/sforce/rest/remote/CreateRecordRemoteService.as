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
package com.touchpointlabs.sforce.rest.remote
{
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.RestRemoteService;

	import flash.events.EventDispatcher;

	import mx.utils.StringUtil;


	public class CreateRecordRemoteService extends EventDispatcher
	{

		public function CreateRecordRemoteService(restApi : RestRemoteService, logFactory : LogFactory)
		{
			this.restApi = restApi;
			this.log = logFactory.getLogger(CreateRecordRemoteService);
			log.debug("constructor");
		}


		public function call(jsonRecord : Object, recordType : String) : void
		{
			var url : String = StringUtil.substitute(urlTemplate, recordType);
			restApi.appendToUrl(url);
			restApi.addJsonResultListener(onResult);
			restApi.setJsonParameter(jsonRecord);
			log.debug("call");
			restApi.call();
		}


		public function setAccessToken(accessToken : String) : void
		{
			restApi.setAccessToken(accessToken);
		}


		public function setOrgInstanceUrl(url : String) : void
		{
			restApi.setOrgInstanceUrl(url);
		}


		protected function onResult(jsonResponse : Object) : void
		{
			log.debug("onResult {0}", jsonResponse);

			restApi.removeJsonResultListener(onResult);

			dispatchEvent(new RecordEvent(jsonResponse.data.id));
		}


		private var restApi : RestRemoteService;

		private var log : Logger;

		private static const urlTemplate : String = "sobjects/{0}/";
	}
}
