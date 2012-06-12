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
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.SetupResult;
	import asmock.framework.constraints.Is;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.RecordedTransaction;
	import com.touchpointlabs.eb.domain.entity.SalesforceRecordedTransaction;
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
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import org.flexunit.assertThat;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;


	public class SfRecordedTransactionDaoTest
	{
		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([SalesforceOrg, UserCredentials, LoginCommandFactory, CreateRecordedTransactionCommandFactory, GetRecordedTransactionCommandFactory, CreateVendorCommandFactory, GetVendorCommandFactory, ListRecordedTransactionsCommandFactory, LoginCommand, CreateRecordedTransactionCommand, GetRecordedTransactionCommand, ListRecordedTransactionsCommand, CreateVendorCommand, GetVendorCommand, RecordedTransaction, SalesforceRecordedTransaction, Envelope, Vendor, Logger, LogFactory]);

		private var mockRepository : MockRepository;

		private var organization : SalesforceOrg;
		private var credentials : UserCredentials;

		private var loginCommandFactory : LoginCommandFactory;
		private var loginCommand : LoginCommand;
		private var createRecordedTransactionCommandFactory : CreateRecordedTransactionCommandFactory;
		private var createRecordedTransactionCommand : CreateRecordedTransactionCommand;
		private var getRecordedTransactionCommandFactory : GetRecordedTransactionCommandFactory;
		private var getRecordedTransactionCommand : GetRecordedTransactionCommand;
		private var createVendorCommandFactory : CreateVendorCommandFactory;
		private var createVendorCommand : CreateVendorCommand;
		private var getVendorCommandFactory : GetVendorCommandFactory;
		private var getVendorCommand : GetVendorCommand;
		private var listRecordedTransactionsCommandFactory : ListRecordedTransactionsCommandFactory;
		private var listRecordedTransactionsCommand : ListRecordedTransactionsCommand;
		private var logFactory : LogFactory;


		private var dao : RecordedTransactionDao;

		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			logFactory = LoggingSupport.mockLogger();

			organization = SalesforceOrg(mockRepository.createStrict(SalesforceOrg, [null, null, null]));
			credentials = UserCredentials(mockRepository.createStrict(UserCredentials, [null, null, null]));

			loginCommandFactory = LoginCommandFactory(mockRepository.createStrict(LoginCommandFactory));
			loginCommand = LoginCommand(mockRepository.createStrict(LoginCommand));
			SetupResult.forCall(loginCommandFactory.newLoginCommand()).returnValue(loginCommand);

			createRecordedTransactionCommandFactory = CreateRecordedTransactionCommandFactory(mockRepository.createStrict(CreateRecordedTransactionCommandFactory));
			createRecordedTransactionCommand = CreateRecordedTransactionCommand(mockRepository.createStrict(CreateRecordedTransactionCommand, [null, logFactory]));
			SetupResult.forCall(createRecordedTransactionCommandFactory.newCreateRecordedTransactionCommand()).returnValue(createRecordedTransactionCommand);

			getRecordedTransactionCommandFactory = GetRecordedTransactionCommandFactory(mockRepository.createStrict(GetRecordedTransactionCommandFactory));
			getRecordedTransactionCommand = GetRecordedTransactionCommand(mockRepository.createStrict(GetRecordedTransactionCommand, [null, logFactory]));
			SetupResult.forCall(getRecordedTransactionCommandFactory.newGetRecordedTransactionCommand()).returnValue(getRecordedTransactionCommand);

			createVendorCommandFactory = CreateVendorCommandFactory(mockRepository.createStrict(CreateVendorCommandFactory));
			createVendorCommand = CreateVendorCommand(mockRepository.createStrict(CreateVendorCommand, [null, logFactory]));
			SetupResult.forCall(createVendorCommandFactory.newCreateVendorCommand()).returnValue(createVendorCommand);

			getVendorCommandFactory = GetVendorCommandFactory(mockRepository.createStrict(GetVendorCommandFactory));
			getVendorCommand = GetVendorCommand(mockRepository.createStrict(GetVendorCommand, [null, logFactory]));
			SetupResult.forCall(getVendorCommandFactory.newGetVendorCommand()).returnValue(getVendorCommand);

			listRecordedTransactionsCommandFactory = ListRecordedTransactionsCommandFactory(mockRepository.createStrict(ListRecordedTransactionsCommandFactory));
			listRecordedTransactionsCommand = ListRecordedTransactionsCommand(mockRepository.createStrict(ListRecordedTransactionsCommand, [null, logFactory]));
			SetupResult.forCall(listRecordedTransactionsCommandFactory.newListRecordedTransactionsCommand()).returnValue(listRecordedTransactionsCommand);
		}


		[After]
		public function tearDown() : void
		{
			mockRepository = null;
			organization = null;
			credentials = null;
			loginCommandFactory = null;
			loginCommand = null;
			createRecordedTransactionCommandFactory = null;
			createRecordedTransactionCommand = null;
			getRecordedTransactionCommandFactory = null;
			getRecordedTransactionCommand = null;
			createVendorCommandFactory = null
			createVendorCommand = null;
			getVendorCommandFactory = null;
			getVendorCommand = null;
			listRecordedTransactionsCommandFactory = null;
			listRecordedTransactionsCommand = null;
		}


		[Test]
		public function testConstructor() : void
		{
			mockRepository.replayAll();

			dao = new SfRecordedTransactionDao(organization, credentials, loginCommandFactory, createRecordedTransactionCommandFactory, getRecordedTransactionCommandFactory, createVendorCommandFactory, getVendorCommandFactory, listRecordedTransactionsCommandFactory, logFactory);

			mockRepository.verifyAll();
		}


		[Test]
		public function testCreate() : void
		{
			var envelope : Envelope = Envelope(mockRepository.createStrict(Envelope));
			var transactionName : String = "Lunch";
			var transactionAmount : Money = new Money(16.00);
			var vendor : Vendor = Vendor(mockRepository.createStrict(Vendor));
			var transactionDate : Date = new Date(2012, 05, 06, 23, 59, 45);
			var listToPopulate : IList = new ArrayCollection();

			var recordedTransactionSfidFixture : String = "AAAboedfjodsp";
			var recordedTransactionFixture : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));


			Expect.call(loginCommand.execute(null, null)).constraints([Is.typeOf(Function), Is.equal(credentials)]).doAction(function(callback : Function, credentials : UserCredentials) : void
			{
				callback(organization);
			});

			Expect.call(createRecordedTransactionCommand.execute(null, null, null)).constraints([Is.typeOf(Function), Is.typeOf(SalesforceOrg), Is.typeOf(CommandContext)]).doAction(function(callback : Function, org : SalesforceOrg, context : CommandContext) : void
			{
				callback(recordedTransactionSfidFixture);
			});

			Expect.call(getRecordedTransactionCommand.execute(null, null, null)).constraints([Is.typeOf(Function), Is.typeOf(SalesforceOrg), Is.typeOf(CommandContext)]).doAction(function(callback : Function, org : SalesforceOrg, context : CommandContext) : void
			{
				callback(recordedTransactionFixture);
			});

			mockRepository.replayAll();
			dao = new SfRecordedTransactionDao(organization, credentials, loginCommandFactory, createRecordedTransactionCommandFactory, getRecordedTransactionCommandFactory, createVendorCommandFactory, getVendorCommandFactory, listRecordedTransactionsCommandFactory, logFactory);

			dao.create(envelope, transactionName, transactionAmount, vendor, transactionDate, listToPopulate);

			assertThat(listToPopulate, arrayWithSize(1));
			assertThat(listToPopulate, everyItem(isA(RecordedTransaction)));
			assertThat(listToPopulate, hasItem(equalTo(recordedTransactionFixture)));

			mockRepository.verifyAll();
		}


		[Test]
		public function testCreateTransactionAndVendor() : void
		{
			var envelope : Envelope = Envelope(mockRepository.createStrict(Envelope));
			var transactionName : String = "Lunch";
			var transactionAmount : Money = new Money(16.00);
			var vendorNameFixture : String = "Costa Coffee";
			var transactionDate : Date = new Date(2012, 05, 06, 23, 59, 45);
			var recordedTransactionListToPopulate : IList = new ArrayCollection();

			var vendorIdFixture : String = "AAaijoaifij.did";
			var vendorFixture : Vendor = Vendor(mockRepository.createStrict(Vendor));
			var vendorListToPopulate : IList = new ArrayCollection();

			var recordedTransactionSfidFixture : String = "AAAboedfjodsp";
			var recordedTransactionFixture : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));

			mockRepository.ordered(function() : void
			{
				Expect.call(loginCommand.execute(null, null)).constraints([Is.typeOf(Function), Is.equal(credentials)]).doAction(function(callback : Function, credentials : UserCredentials) : void
				{
					callback(organization);
				});


				Expect.call(createVendorCommand.execute(null, null, null)).constraints([Is.typeOf(Function), Is.typeOf(SalesforceOrg), Is.typeOf(CommandContext)]).doAction(function(callback : Function, org : SalesforceOrg, context : CommandContext) : void
				{
					callback(vendorIdFixture);
				});


				Expect.call(getVendorCommand.execute(null, null, null)).constraints([Is.typeOf(Function), Is.typeOf(SalesforceOrg), Is.typeOf(CommandContext)]).doAction(function(callback : Function, org : SalesforceOrg, context : CommandContext) : void
				{
					callback(vendorFixture);
				});

				Expect.call(loginCommand.execute(null, null)).constraints([Is.typeOf(Function), Is.equal(credentials)]).doAction(function(callback : Function, credentials : UserCredentials) : void
				{
					callback(organization);
				});

				Expect.call(createRecordedTransactionCommand.execute(null, null, null)).constraints([Is.typeOf(Function), Is.typeOf(SalesforceOrg), Is.typeOf(CommandContext)]).doAction(function(callback : Function, org : SalesforceOrg, context : CommandContext) : void
				{
					callback(recordedTransactionSfidFixture);
				});

				Expect.call(getRecordedTransactionCommand.execute(null, null, null)).constraints([Is.typeOf(Function), Is.typeOf(SalesforceOrg), Is.typeOf(CommandContext)]).doAction(function(callback : Function, org : SalesforceOrg, context : CommandContext) : void
				{
					callback(recordedTransactionFixture);
				});
			});

			mockRepository.replayAll();
			dao = new SfRecordedTransactionDao(organization, credentials, loginCommandFactory, createRecordedTransactionCommandFactory, getRecordedTransactionCommandFactory, createVendorCommandFactory, getVendorCommandFactory, listRecordedTransactionsCommandFactory, logFactory);

			dao.createTransactionAndVendor(envelope, transactionName, transactionAmount, vendorNameFixture, transactionDate, recordedTransactionListToPopulate, vendorListToPopulate);

			assertThat(recordedTransactionListToPopulate, arrayWithSize(1));
			assertThat(recordedTransactionListToPopulate, everyItem(isA(RecordedTransaction)));
			assertThat(recordedTransactionListToPopulate, hasItem(equalTo(recordedTransactionFixture)));

			assertThat(vendorListToPopulate, arrayWithSize(1));
			assertThat(vendorListToPopulate, everyItem(isA(Vendor)));
			assertThat(vendorListToPopulate, hasItem(equalTo(vendorFixture)));

			mockRepository.verifyAll();
		}


		[Test]
		public function testFindAll() : void
		{
			var listToPopulate : IList = new ArrayCollection();

			var transaction1 : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
			SetupResult.forCall(transaction1.id).returnValue(1);

			var transaction2 : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
			SetupResult.forCall(transaction2.id).returnValue(2);

			var transaction3 : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
			SetupResult.forCall(transaction3.id).returnValue(3);

			var all : IList = new ArrayCollection([transaction1, transaction2, transaction3]);

			Expect.call(loginCommand.execute(null, null)).constraints([Is.typeOf(Function), Is.equal(credentials)]).doAction(function(callback : Function, credentials : UserCredentials) : void
			{
				callback(organization);
			});

			Expect.call(listRecordedTransactionsCommand.execute(null, null, null)).constraints([Is.typeOf(Function), Is.typeOf(SalesforceOrg), Is.typeOf(CommandContext)]).doAction(function(callback : Function, org : SalesforceOrg, context : CommandContext) : void
			{
				callback(all);
			});

			mockRepository.replayAll();

			dao = new SfRecordedTransactionDao(organization, credentials, loginCommandFactory, createRecordedTransactionCommandFactory, getRecordedTransactionCommandFactory, createVendorCommandFactory, getVendorCommandFactory, listRecordedTransactionsCommandFactory, logFactory);

			dao.findAll(listToPopulate);

			mockRepository.verifyAll();

			assertThat(listToPopulate, arrayWithSize(3));
			assertThat(listToPopulate, everyItem(isA(RecordedTransaction)));
			assertThat(listToPopulate, hasItems(equalTo(transaction1), equalTo(transaction2), equalTo(transaction3)));

			mockRepository.verifyAll();
		}
	}
}
