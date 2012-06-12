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
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.SetupResult;
	import asmock.framework.constraints.Is;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.SalesforceEnvelope;
	import com.touchpointlabs.eb.domain.entity.SalesforceVendor;
	import com.touchpointlabs.eb.domain.vo.Money;
	import com.touchpointlabs.eb.integration.api.CommandContext;
	import com.touchpointlabs.eb.integration.api.ContextKeyNotFoundFaultEvent;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;
	import com.touchpointlabs.sforce.rest.remote.CreateRecordRemoteService;
	import com.touchpointlabs.sforce.rest.remote.RecordEvent;

	import mx.rpc.Fault;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.text.containsString;
	import org.hamcrest.text.startsWith;

	public class CreateRecordedTransactionCommandTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([CreateRecordRemoteService, CommandContext, SalesforceOrg, Logger, LogFactory]);

		private var mockRepository : MockRepository;
		private var remoteService : CreateRecordRemoteService;
		private var organization : SalesforceOrg;
		private var context : CommandContext;
		private var logFactory : LogFactory;

		private var command : CreateRecordedTransactionCommand;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			logFactory = LoggingSupport.mockLoggerForClass(CreateRecordedTransactionCommand, mockRepository, LoggingSupport.LOG_LEVEL_DEBUG, true);
			var serviceLogFactory : LogFactory = LoggingSupport.mockLoggerForClass(CreateRecordRemoteService);
			remoteService = CreateRecordRemoteService(mockRepository.createStrict(CreateRecordRemoteService, [null, serviceLogFactory]));
			var contextLogFactory : LogFactory = LoggingSupport.mockLoggerForClass(CommandContext);
			context = CommandContext(mockRepository.createStrict(CommandContext, [contextLogFactory]));
			organization = SalesforceOrg(mockRepository.createStrict(SalesforceOrg, [null, null, null]));
		}


		[After]
		public function tearDown() : void
		{
			remoteService = null;
			mockRepository = null;
			command = null;
			context = null;
			organization = null;
		}


		[Test]
		public function testConstructor() : void
		{
			mockRepository.replay(remoteService);

			command = new CreateRecordedTransactionCommand(remoteService, logFactory);

			mockRepository.verify(remoteService);
		}


		[Test(async)]
		public function testExecute() : void
		{
			var transactionNameFixture : String = "Lunch";
			var envelopeIdFixture : int = 1;
			var envelopeNameFixture : String = "Meals";
			var envelopeSfidFixture : String = "AAAkjfgksjf933";
			var envelopeFixture : Envelope = new SalesforceEnvelope(makeJson(envelopeIdFixture, envelopeNameFixture, envelopeSfidFixture, "EnvelopeId__c"));
			var vendorIdFixture : int = 2;
			var vendorNameFixture : String = "McDonalds (forgive me for my sin!)";
			var vendorSfidFixture : String = "BBBesfu89eusd89es";
			var vendorFixture : SalesforceVendor = new SalesforceVendor(makeJson(vendorIdFixture, vendorNameFixture, vendorSfidFixture, "VendorId__c"));
			var amountFixture : Money = new Money(3.50);
			var dateFixture : Date = new Date(2012, 05, 06, 01, 30, 45);

			var createdRecordedTransactionSfidFixture : String = "AAAbbbcjs8u89ef";

			var onResultListener : Function;

			mockRepository.ordered(function() : void
			{
				// check the context contains what it needs
				Expect.call(context.exists(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_NAME)]).returnValue(true);
				Expect.call(context.exists(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_ENVELOPE)]).returnValue(true);
				Expect.call(context.exists(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_VENDOR)]).returnValue(true);
				Expect.call(context.exists(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_AMOUNT)]).returnValue(true);
				Expect.call(context.exists(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_DATE)]).returnValue(true);
			});
			// transfer the accessToken and url from the org to the remote service
			Expect.call(organization.accessToken).returnValue("accessToken");
			Expect.call(remoteService.setAccessToken(null)).constraints([Is.equal("accessToken")]);
			Expect.call(organization.url).returnValue("url");
			Expect.call(remoteService.setOrgInstanceUrl(null)).constraints([Is.equal("url")]);

			mockRepository.ordered(function() : void
			{
				// get from the context the various values for the transaction that will be created
				Expect.call(context.get(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_NAME)]).returnValue(transactionNameFixture);
				Expect.call(context.get(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_ENVELOPE)]).returnValue(envelopeFixture);
				Expect.call(context.get(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_VENDOR)]).returnValue(vendorFixture);
				Expect.call(context.get(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_AMOUNT)]).returnValue(amountFixture);
				Expect.call(context.get(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_DATE)]).returnValue(dateFixture);
			});

			Expect.call(remoteService.addEventListener(null, null)).constraints([Is.equal(RecordEvent.RECORD), Is.typeOf(Function)]).doAction(function(type : String, listener : Function) : void
			{
				// note 1
				// unfortunately this code is needed to simulate the internal adding of an event listener to the service
				// since we are mocking the adding of an event, nothing will happen, so we have to call the listener manually
				// in the doAction of the Expect.call(remoteService.call(..  below
				onResultListener = listener;
			});

			// note 2 - There seems to be a problem guaranteeing that the Expect.call will always suceed as the jsonRecord object seems to be stringyfied differently
			// each time. If this is changed to Expect.call and .constraints Is.anything used, this still doesn't work, so I have to resort to use SetupResult.forCall
			// and assert it is called by using a flag
			var callCalled : Boolean = false;
			SetupResult.forCall(remoteService.call(null, null)).ignoreArguments().doAction(function(jsonRecord : Object, recordType : String) : void
			{
				callCalled = true;
				// see note 1 (above)
				var recordEvent : RecordEvent = new RecordEvent(createdRecordedTransactionSfidFixture);
				onResultListener(recordEvent);
			});



			Expect.call(remoteService.removeEventListener(null, null)).ignoreArguments();

			mockRepository.ordered(function() : void
			{
				// tidy up context
				Expect.call(context.remove(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_AMOUNT)]).returnValue(true);
				Expect.call(context.remove(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_DATE)]).returnValue(true);
				Expect.call(context.remove(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_ENVELOPE)]).returnValue(true);
				Expect.call(context.remove(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_NAME)]).returnValue(true);
				Expect.call(context.remove(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_VENDOR)]).returnValue(true);
			});

			// add the new id into the context incase needed by a downstream GetRecordedTransactionCommand
			Expect.call(context.add(null, null)).constraints([Is.equal(GetRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_ID), Is.equal(createdRecordedTransactionSfidFixture)]);

			mockRepository.replayAll();

			command = new CreateRecordedTransactionCommand(remoteService, logFactory);

			command.execute(function(result : Object) : void
			{
				assertEquals(createdRecordedTransactionSfidFixture, result);
			}, organization, context);

			mockRepository.verifyAll();

			assertTrue(callCalled);
		}


		private function makeJson(id : int, name : String, sfid : String, recordExternalIdName : String) : Object
		{
			var record : Object = new Object();
			record.Id = sfid;
			record.Name = name;
			record[recordExternalIdName] = id;
			return record;
		}

		[Test]
		public function testExecuteWithMissingKeyName() : void
		{
			testExecuteWithBadContext(false, true, true, true, true);
		}


		[Test]
		public function testExecuteWithMissingKeyEnvelope() : void
		{
			testExecuteWithBadContext(true, false, true, true, true);
		}


		[Test]
		public function testExecuteWithMissingKeyVendor() : void
		{
			testExecuteWithBadContext(true, true, false, true, true);
		}


		[Test]
		public function testExecuteWithMissingKeyAmount() : void
		{
			testExecuteWithBadContext(true, true, true, false, true);
		}


		[Test]
		public function testExecuteWithMissingKeyDate() : void
		{
			testExecuteWithBadContext(true, true, true, true, false);
		}


		[Test]
		public function testExecuteWithMultipleMissingKeys() : void
		{
			testExecuteWithBadContext(true, false, false, true, true);
		}


		private function testExecuteWithBadContext(transactionNameExists : Boolean, envelopeExists : Boolean, vendorExists : Boolean, amountExists : Boolean, dateExists : Boolean) : void
		{

			mockRepository.ordered(function() : void
			{
				// check the context contains what it needs
				Expect.call(context.exists(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_NAME)]).returnValue(transactionNameExists);
				Expect.call(context.exists(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_ENVELOPE)]).returnValue(envelopeExists);
				Expect.call(context.exists(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_VENDOR)]).returnValue(vendorExists);
				Expect.call(context.exists(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_AMOUNT)]).returnValue(amountExists);
				Expect.call(context.exists(null)).constraints([Is.equal(CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_DATE)]).returnValue(dateExists);
			});

			mockRepository.replayAll();

			command = new CreateRecordedTransactionCommand(remoteService, logFactory);

			command.execute(function(result : Object) : void
			{
				assertThat(result, instanceOf(ContextKeyNotFoundFaultEvent));

				var event : ContextKeyNotFoundFaultEvent = ContextKeyNotFoundFaultEvent(result);
				var fault : Fault = event.fault;

				assertEquals("9001", fault.faultCode);
				assertThat(fault.faultDetail, startsWith("The CommandContext could not find the key with the name  "));


				assertFaultCorrectForField(transactionNameExists, CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_NAME, fault);
				assertFaultCorrectForField(envelopeExists, CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_ENVELOPE, fault);
				assertFaultCorrectForField(vendorExists, CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_VENDOR, fault);
				assertFaultCorrectForField(amountExists, CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_AMOUNT, fault);
				assertFaultCorrectForField(dateExists, CreateRecordedTransactionCommand.KEY_RECORDED_TRANSACTION_DATE, fault);

			}, organization, context);


			mockRepository.verifyAll();
		}


		private function assertFaultCorrectForField(exists : Boolean, key : String, fault : Fault) : void
		{
			if (!exists)
			{
				assertThat(fault.faultDetail, containsString(key));
				assertThat(fault.faultString, containsString(key));
			}
		}
	}
}
