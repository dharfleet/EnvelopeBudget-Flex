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
	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.SalesforceEnvelope;
	import com.touchpointlabs.eb.domain.entity.SalesforceVendor;
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.domain.vo.Money;
	import com.touchpointlabs.eb.integration.api.CommandContext;
	import com.touchpointlabs.eb.integration.api.ContextKeyNotFoundFaultEvent;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;
	import com.touchpointlabs.sforce.rest.date.SalesforceDateTranslator;
	import com.touchpointlabs.sforce.rest.remote.CreateRecordRemoteService;
	import com.touchpointlabs.sforce.rest.remote.RecordEvent;

	public class CreateRecordedTransactionCommand
	{

		public static const KEY_RECORDED_TRANSACTION_NAME : String = "RECORDED_TRANSACTION_NAME";
		public static const KEY_RECORDED_TRANSACTION_ENVELOPE : String = "RECORDED_TRANSACTION_ENVELOPE";
		public static const KEY_RECORDED_TRANSACTION_VENDOR : String = "RECORDED_TRANSACTION_VENDOR";
		public static const KEY_RECORDED_TRANSACTION_AMOUNT : String = "RECORDED_TRANSACTION_AMOUNT";
		public static const KEY_RECORDED_TRANSACTION_DATE : String = "RECORDED_TRANSACTION_DATE";


		public function CreateRecordedTransactionCommand(remoteService : CreateRecordRemoteService, logFactory : LogFactory)
		{
			this.remoteService = remoteService;
			this.log = logFactory.getLogger(CreateRecordedTransactionCommand);
			this.log.debug("constructor");
		}


		public function execute(callback : Function, organization : SalesforceOrg, context : CommandContext) : void
		{
			this._callback = callback;
			this.context = context;

			if (!contextIsValid())
			{
				log.prettyPrintObjectIfDebugEnabled(context, "context not found to contain everything the command needs");
				callback(new ContextKeyNotFoundFaultEvent(keysNotFound));
			}
			else
			{
				remoteService.setAccessToken(organization.accessToken);
				remoteService.setOrgInstanceUrl(organization.url);


				var transactionName : String = String(context.get(KEY_RECORDED_TRANSACTION_NAME));
				var envelope : Envelope = Envelope(context.get(KEY_RECORDED_TRANSACTION_ENVELOPE));
				var vendor : Vendor = Vendor(context.get(KEY_RECORDED_TRANSACTION_VENDOR));
				var amount : Money = Money(context.get(KEY_RECORDED_TRANSACTION_AMOUNT));
				var date : Date = context.get(KEY_RECORDED_TRANSACTION_DATE) as Date;

				var recordedTransaction : Object = new Object();
				recordedTransaction.Name = transactionName;
				recordedTransaction.amount__c = amount.amount;
				recordedTransaction.date__c = SalesforceDateTranslator.toISO8601(date);
				recordedTransaction.envelope__c = SalesforceEnvelope(envelope).sfid;
				recordedTransaction.vendor__c = SalesforceVendor(vendor).sfid;

				var jsonRecordedTransaction : Object = JSON.stringify(recordedTransaction);

				remoteService.addEventListener(RecordEvent.RECORD, onResult);

				log.debug("calling remote service");
				remoteService.call(jsonRecordedTransaction, "RecordedTransaction__c");
			}
		}


		protected function onResult(recordEvent : RecordEvent) : void
		{
			log.prettyPrintObjectIfDebugEnabled(recordEvent.record, "created record");

			remoteService.removeEventListener(RecordEvent.RECORD, onResult);
			tidyUpContext();

			var recordedTransactionId : String = String(recordEvent.record);

			context.add(GetRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_ID, recordedTransactionId);
			_callback(recordedTransactionId);
		}


		private function tidyUpContext() : void
		{
			context.remove(KEY_RECORDED_TRANSACTION_AMOUNT);
			context.remove(KEY_RECORDED_TRANSACTION_DATE);
			context.remove(KEY_RECORDED_TRANSACTION_ENVELOPE);
			context.remove(KEY_RECORDED_TRANSACTION_NAME);
			context.remove(KEY_RECORDED_TRANSACTION_VENDOR);
		}


		private function contextIsValid() : Boolean
		{
			// TODO (Future) - think about replacing this with some kind of Specification Pattern class and removing from the command

			var result : Boolean = VALID;
			if (!context.exists(KEY_RECORDED_TRANSACTION_NAME))
			{
				result = INVALID;
				appendKeyNotFound(KEY_RECORDED_TRANSACTION_NAME)
			}
			if (!context.exists(KEY_RECORDED_TRANSACTION_ENVELOPE))
			{
				result = INVALID;
				appendKeyNotFound(KEY_RECORDED_TRANSACTION_ENVELOPE)
			}
			if (!context.exists(KEY_RECORDED_TRANSACTION_VENDOR))
			{
				result = INVALID;
				appendKeyNotFound(KEY_RECORDED_TRANSACTION_VENDOR)
			}
			if (!context.exists(KEY_RECORDED_TRANSACTION_AMOUNT))
			{
				result = INVALID;
				appendKeyNotFound(KEY_RECORDED_TRANSACTION_AMOUNT)
			}
			if (!context.exists(KEY_RECORDED_TRANSACTION_DATE))
			{
				result = INVALID;
				appendKeyNotFound(KEY_RECORDED_TRANSACTION_DATE)
			}
			return result;
		}


		private function appendKeyNotFound(key : String) : void
		{
			keysNotFound += " ";
			keysNotFound += key;
		}

		private var keysNotFound : String = "";


		private var remoteService : CreateRecordRemoteService;
		private var _callback : Function;
		private var context : CommandContext;

		private var log : Logger;

		private static const VALID : Boolean = true;
		private static const INVALID : Boolean = false;
		private static const KEY_NOT_FOUND_ERROR_MESSAGE_TEMPLATE : String = "CreateRecordedTransactionCommand: {0} not present in context";
	}
}
