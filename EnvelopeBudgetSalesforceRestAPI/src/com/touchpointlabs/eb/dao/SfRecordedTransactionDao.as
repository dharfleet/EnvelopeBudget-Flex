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
package com.touchpointlabs.eb.dao
{
	import com.touchpointlabs.collections.ListUtils;
	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.RecordedTransaction;
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.domain.vo.Money;
	import com.touchpointlabs.eb.integration.api.CommandContext;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommand;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommandFactory;
	import com.touchpointlabs.eb.integration.api.authn.UserCredentials;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.CreateRecordedTransactionCommand;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.CreateRecordedTransactionCommandFactory;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.GetRecordedTransactionCommand;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.GetRecordedTransactionCommandFactory;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.ListRecordedTransactionsCommand;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.ListRecordedTransactionsCommandFactory;
	import com.touchpointlabs.eb.integration.api.vendor.CreateVendorCommand;
	import com.touchpointlabs.eb.integration.api.vendor.CreateVendorCommandFactory;
	import com.touchpointlabs.eb.integration.api.vendor.GetVendorCommand;
	import com.touchpointlabs.eb.integration.api.vendor.GetVendorCommandFactory;
	import com.touchpointlabs.eb.integration.dao.RecordedTransactionDao;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import org.spicefactory.lib.command.builder.Commands;

	public class SfRecordedTransactionDao implements RecordedTransactionDao
	{
		public function SfRecordedTransactionDao(organization : SalesforceOrg, credentials : UserCredentials, loginCommandFactory : LoginCommandFactory, createRecordedTransactionCommandFactory : CreateRecordedTransactionCommandFactory, getRecordedTransactionCommandFactory : GetRecordedTransactionCommandFactory, createVendorCommandFactory : CreateVendorCommandFactory, getVendorCommandFactory : GetVendorCommandFactory, listRecordedTransactionsCommandFactory : ListRecordedTransactionsCommandFactory, logFactory : LogFactory)
		{
			this.organization = organization;
			this.credentials = credentials;
			this.logFactory = logFactory;
			this.createContext = new CommandContext(logFactory);

			this.loginCommandFactory = loginCommandFactory;
			this.createRecordedTransactionCommandFactory = createRecordedTransactionCommandFactory;
			this.getRecordedTransactionCommandFactory = getRecordedTransactionCommandFactory;
			this.createVendorCommandFactory = createVendorCommandFactory;
			this.getVendorCommandFactory = getVendorCommandFactory;
			this.listRecordedTransactionsCommandFactory = listRecordedTransactionsCommandFactory;

			this.log = logFactory.getLogger(SfRecordedTransactionDao);
			this.log.debug("Constructor");
		}


		public function create(envelope : Envelope, transactionName : String, transactionAmount : Money, vendor : Vendor, transactionDate : Date, listToPopulate : IList) : void
		{
			this.createRecordedTransactionListToPopulate = listToPopulate;
			log.debug("create, listToPopulate has {0} items", listToPopulate.length);

			createContext.add(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_AMOUNT, transactionAmount);
			createContext.add(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_DATE, transactionDate);
			createContext.add(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_ENVELOPE, envelope);
			createContext.add(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_NAME, transactionName);
			createContext.add(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_VENDOR, vendor);

			log.prettyPrintObjectIfDebugEnabled(createContext);

			var loginCommand : LoginCommand = loginCommandFactory.newLoginCommand();
			var createRecordedTransactionCommmand : CreateRecordedTransactionCommand = createRecordedTransactionCommandFactory.newCreateRecordedTransactionCommand();
			var getRecordedTransactionCommand : GetRecordedTransactionCommand = getRecordedTransactionCommandFactory.newGetRecordedTransactionCommand();

			Commands.asSequence().add(loginCommand).add(createRecordedTransactionCommmand).add(getRecordedTransactionCommand).data(credentials).data(createContext).lastResult(onCreateRecordedTransaction).error(onError).execute();
		}


		public function createTransactionAndVendor(envelope : Envelope, transactionName : String, transactionAmount : Money, vendorName : String, transactionDate : Date, recordedTransactionListToPopulate : IList, vendorListToPopulate : IList) : void
		{
			this.createRecordedTransactionListToPopulate = recordedTransactionListToPopulate;
			this.createVendorListToPopulate = vendorListToPopulate;

			log.debug("createTransactionAndVendor, recordedTransactionListToPopulate has {0} items already", recordedTransactionListToPopulate.length);
			log.debug("createTransactionAndVendor, vendorListToPopulate has {0} items already", vendorListToPopulate.length);

			createContext.add(CreateVendorCommand.KEY_VENDOR_NAME_TO_CREATE, vendorName);

			createContext.add(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_AMOUNT, transactionAmount);
			createContext.add(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_DATE, transactionDate);
			createContext.add(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_ENVELOPE, envelope);
			createContext.add(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_NAME, transactionName);

			var loginCommand : LoginCommand = loginCommandFactory.newLoginCommand();
			var createVendorCommand : CreateVendorCommand = createVendorCommandFactory.newCreateVendorCommand();
			var getVendorCommand : GetVendorCommand = getVendorCommandFactory.newGetVendorCommand();

			Commands.asSequence().add(loginCommand).add(createVendorCommand).add(getVendorCommand).data(credentials).data(createContext).lastResult(onCreateVendorResult).error(onError).execute();
		}


		private function onCreateVendorResult(result : Object) : void
		{
			log.prettyPrintObjectIfDebugEnabled(result, "result of creating vendor");
			createVendorListToPopulate.addItem(result);

			var transactionAmount : Money = Money(createContext.get(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_AMOUNT));
			var transactionDate : Date = createContext.get(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_DATE) as Date;
			var envelope : Envelope = Envelope(createContext.get(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_ENVELOPE));
			var transactionName : String = String(createContext.get(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_NAME));
			var vendor : Vendor = Vendor(result);

			log.prettyPrintObjectIfDebugEnabled(vendor, "vendor created");

			create(envelope, transactionName, transactionAmount, vendor, transactionDate, createRecordedTransactionListToPopulate);
		}


		private function onCreateRecordedTransaction(result : Object) : void
		{
			var newlyCreatedRecordedTransaction : RecordedTransaction = RecordedTransaction(result);
			log.prettyPrintObjectIfDebugEnabled(newlyCreatedRecordedTransaction, "newly created Recorded Transaction");
			createRecordedTransactionListToPopulate.addItem(newlyCreatedRecordedTransaction);
		}


		public function findAll(listToPopulate : IList) : void
		{
			findAllListToPopulate = listToPopulate;

			log.debug("findAll, listToPopulate has {0} items already", listToPopulate.length);

			var listRecordedTransactionsCommand : ListRecordedTransactionsCommand = listRecordedTransactionsCommandFactory.newListRecordedTransactionsCommand();
			var loginCommand : LoginCommand = loginCommandFactory.newLoginCommand();

			Commands.asSequence().add(loginCommand).lastResult(onFindAllResult).error(onError).data(credentials).data(new CommandContext(logFactory)).add(listRecordedTransactionsCommand).execute();
		}


		private function onFindAllResult(result : Object) : void
		{
			var results : IList = result as ArrayCollection;
			log.debug("findAll, remote call found {0} recorded transactions, about to merge with existing", results.length);

			ListUtils.merge(results, findAllListToPopulate, "id");
			log.debug("findAll, the list of recorded transactions is {0} long after merging", findAllListToPopulate.length);
		}


		private function onError(cause : Object) : void
		{
			log.error("an error occured: {0}", cause);
			log.prettyPrintObjectIfDebugEnabled(cause);
		}


		private var organization : SalesforceOrg;
		private var credentials : UserCredentials;
		private var logFactory : LogFactory;

		private var findAllListToPopulate : IList;
		private var createRecordedTransactionListToPopulate : IList;
		private var createVendorListToPopulate : IList;
		private var createContext : CommandContext;

		private var loginCommandFactory : LoginCommandFactory;
		private var createRecordedTransactionCommandFactory : CreateRecordedTransactionCommandFactory;
		private var getRecordedTransactionCommandFactory : GetRecordedTransactionCommandFactory;
		private var createVendorCommandFactory : CreateVendorCommandFactory;
		private var getVendorCommandFactory : GetVendorCommandFactory;
		private var listRecordedTransactionsCommandFactory : ListRecordedTransactionsCommandFactory;

		private var log : Logger;
	}
}
