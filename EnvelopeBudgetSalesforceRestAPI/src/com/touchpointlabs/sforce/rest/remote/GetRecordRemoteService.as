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
	import com.touchpointlabs.sforce.rest.JsonResultEvent;
	import com.touchpointlabs.sforce.rest.RestRemoteService;

	import flash.events.EventDispatcher;

	import mx.utils.StringUtil;


	public class GetRecordRemoteService extends EventDispatcher
	{

		public function GetRecordRemoteService(restApi : RestRemoteService, logFactory : LogFactory)
		{
			this.restApi = restApi;
			this.log = logFactory.getLogger(GetRecordRemoteService);
			this.log.debug("constructor");
		}


		public function call(recordId : String, sfRecordName : String) : void
		{
			var endOfUrl : String = StringUtil.substitute(urlTemplate, sfRecordName, recordId);

			restApi.appendToUrl(endOfUrl);

			restApi.addJsonResultListener(handleJsonResult);

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


		private function handleJsonResult(jsonResultEvent : JsonResultEvent) : void
		{
			log.debug("handleJsonResult, dispatching {0}", jsonResultEvent);
			restApi.removeJsonResultListener(handleJsonResult);
			dispatchEvent(jsonResultEvent);
		}


		private var restApi : RestRemoteService;

		private var log : Logger;

		private static const urlTemplate : String = "sobjects/{0}/{1}";

	}
}
