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
package com.touchpointlabs.eb.integration.api.recordedtransactions
{
	import com.touchpointlabs.eb.domain.entity.RecordedTransaction;
	import com.touchpointlabs.eb.domain.entity.SalesforceRecordedTransaction;
	import com.touchpointlabs.eb.integration.api.CommandContext;
	import com.touchpointlabs.eb.integration.api.ContextKeyNotFoundFaultEvent;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;
	import com.touchpointlabs.sforce.rest.remote.SoqlQueryRemoteService;
	import com.touchpointlabs.sforce.rest.remote.SoqlQueryResultEvent;

	import mx.utils.StringUtil;

	public class GetRecordedTransactionCommand
	{
		public static const KEY_RECORDED_TRANSACTION_ID : String = "RECORDED_TRANSACTION_ID";


		public function GetRecordedTransactionCommand(api : SoqlQueryRemoteService, logFactory : LogFactory)
		{
			this.api = api;
			this.log = logFactory.getLogger(GetRecordedTransactionCommand);
			this.log.debug("constructor");
		}


		public function execute(callback : Function, organization : SalesforceOrg, context : CommandContext) : void
		{
			this.callback = callback;
			this.context = context;

			api.setAccessToken(organization.accessToken);
			api.setOrgInstanceUrl(organization.url);

			api.addEventListener(SoqlQueryResultEvent.RESULT, onResult);

			if (!context.exists(KEY_RECORDED_TRANSACTION_ID))
			{
				log.prettyPrintObjectIfDebugEnabled(context, "context not found to contain everything the command needs");
				callback(new ContextKeyNotFoundFaultEvent(KEY_RECORDED_TRANSACTION_ID));
			}
			else
			{
				var transactionId : String = String(context.get(KEY_RECORDED_TRANSACTION_ID));
				var soqlQuery : String = StringUtil.substitute(SOQL_TEMPLATE, transactionId);

				log.debug("calling remote service with query:{0}", soqlQuery);
				api.executeQuery(soqlQuery);
			}
		}


		protected function onResult(event : SoqlQueryResultEvent) : void
		{
			api.removeEventListener(SoqlQueryResultEvent.RESULT, onResult);

			var record : Object = event.records[0];

			var transaction : RecordedTransaction = new SalesforceRecordedTransaction(record);
			callback(transaction);
		}


		private var api : SoqlQueryRemoteService;
		private var callback : Function;
		private var context : CommandContext;

		private var log : Logger;

		private static const SOQL_TEMPLATE : String = "SELECT t.recordedTransactionId__c, t.Id, t.Name, t.amount__c, t.date__c, t.envelope__c, t.vendor__c, t.vendor__r.Id, t.vendor__r.Name,t.vendor__r.VendorId__c, t.envelope__r.Id, t.envelope__r.Name, t.envelope__r.EnvelopeId__c FROM RecordedTransaction__c t WHERE t.ID = '{0}'";

	}
}
