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
package com.touchpointlabs.eb.integration.api.envelope
{
	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.SalesforceEnvelope;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.JsonResultEvent;
	import com.touchpointlabs.sforce.rest.remote.GetRecordRemoteService;
	import com.touchpointlabs.sforce.rest.remote.RecordEvent;

	import flash.events.EventDispatcher;


	public class GetEnvelopeRemoteService extends EventDispatcher
	{
		public function GetEnvelopeRemoteService(getRecordRemoteService : GetRecordRemoteService, logFactory : LogFactory, envelopeRecordName : String="Envelope__c")
		{
			this.getRecordRemoteService = getRecordRemoteService;
			this.envelopeRecordName = envelopeRecordName;
			this.log = logFactory.getLogger(GetEnvelopeRemoteService);
			this.log.debug("constructor");
		}


		public function callGetEnvelope(recordId : String) : void
		{
			log.debug("callGetEnvelope id: {0}", recordId);

			getRecordRemoteService.addEventListener(JsonResultEvent.RESULT, onResult);

			getRecordRemoteService.call(recordId, envelopeRecordName);
		}


		public function setAccessToken(accessToken : String) : void
		{
			getRecordRemoteService.setAccessToken(accessToken);
		}


		public function setOrgInstanceUrl(url : String) : void
		{
			getRecordRemoteService.setOrgInstanceUrl(url);
		}


		protected function onResult(resultEvent : JsonResultEvent) : void
		{
			log.prettyPrintObjectIfDebugEnabled(resultEvent.data);

			getRecordRemoteService.removeEventListener(JsonResultEvent.RESULT, onResult);

			var envelope : Envelope = new SalesforceEnvelope(resultEvent.data);
			dispatchEvent(new RecordEvent(envelope));
		}


		private var getRecordRemoteService : GetRecordRemoteService;
		private var envelopeRecordName : String

		private var log : Logger;
	}
}
