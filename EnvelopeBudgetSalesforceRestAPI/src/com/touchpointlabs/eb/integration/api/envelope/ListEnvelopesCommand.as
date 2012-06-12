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
	import com.touchpointlabs.eb.integration.api.CommandContext;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;
	import com.touchpointlabs.sforce.rest.remote.SoqlQueryRemoteService;
	import com.touchpointlabs.sforce.rest.remote.SoqlQueryResultEvent;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	public class ListEnvelopesCommand
	{

		public function ListEnvelopesCommand(api : SoqlQueryRemoteService, logFactory : LogFactory)
		{
			this.api = api;
			log = logFactory.getLogger(ListEnvelopesCommand);
			log.debug("constructor");
		}


		public function execute(callback : Function, organization : SalesforceOrg, context : CommandContext) : void
		{
			this.callback = callback;
			this.context = context;

			api.setAccessToken(organization.accessToken);
			api.setOrgInstanceUrl(organization.url);

			api.addEventListener(SoqlQueryResultEvent.RESULT, onResult);

			log.debug("execute {0}", QUERY);
			api.executeQuery(QUERY);
		}


		protected function onResult(event : SoqlQueryResultEvent) : void
		{
			log.prettyPrintObjectIfDebugEnabled(event.records, "onResult");

			api.removeEventListener(SoqlQueryResultEvent.RESULT, onResult);

			var envelopes : IList = new ArrayCollection();
			for each (var record : Object in event.records)
			{
				var envelope : Envelope = new SalesforceEnvelope(record);
				envelopes.addItem(envelope);
			}
			callback(envelopes);
		}


		private var api : SoqlQueryRemoteService;
		private var callback : Function;
		private var context : CommandContext;

		private static const QUERY : String = "SELECT EnvelopeId__c, Id, Name FROM Envelope__c";

		private var log : Logger
	}
}
