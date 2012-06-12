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
package com.touchpointlabs.eb.presentation
{
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.SetupResult;
	import asmock.framework.constraints.AbstractConstraint;
	import asmock.framework.constraints.And;
	import asmock.framework.constraints.Is;
	import asmock.framework.constraints.Property;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.RecordedTransaction;
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.domain.service.EnvelopeService;
	import com.touchpointlabs.eb.domain.service.RecordedTransactionService;
	import com.touchpointlabs.eb.domain.service.VendorService;
	import com.touchpointlabs.eb.domain.vo.Money;
	import com.touchpointlabs.eb.presentation.navigation.Navigation;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import org.flexunit.assertThat;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class RecordATransactionPMTest
	{
		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([RecordedTransactionService, VendorService, EnvelopeService, Navigation, LogFactory, Logger, Envelope, Vendor, RecordedTransaction]);

		private var mockRepository : MockRepository;

		private var recordedTransactionService : RecordedTransactionService;
		private var envelopeService : EnvelopeService;
		private var vendorService : VendorService;
		private var navigation : Navigation;
		private var logFactory : LogFactory;
		private var pm : RecordATransactionPM;

		private var vendor1 : Vendor;
		private var vendor2 : Vendor;
		private var vendor3 : Vendor;

		private var envelope1 : Envelope;
		private var envelope2 : Envelope;

		private var transactionNameFixture : String;
		private var transactionDateFixture : Date;
		private var transactionAmountFixture : Money;

		private var envelopeConstraint : AbstractConstraint;
		private var transactionNameConstraint : AbstractConstraint;
		private var transactionAmountConstraint : AbstractConstraint;
		private var dateConstraint : AbstractConstraint;
		private var resultHolderConstraint : AbstractConstraint;
		private var vendorConstraint : AbstractConstraint;
		private var vendorNameConstraint : AbstractConstraint;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			recordedTransactionService = RecordedTransactionService(mockRepository.createStrict(RecordedTransactionService));
			envelopeService = EnvelopeService(mockRepository.createStrict(EnvelopeService));
			vendorService = VendorService(mockRepository.createStrict(VendorService));
			navigation = Navigation(mockRepository.createStrict(Navigation));
			logFactory = LoggingSupport.mockLoggerForClass(RecordATransactionPM, mockRepository, LoggingSupport.LOG_LEVEL_DEBUG, true);
			setUpVendors();
			setUpEnvelopes();
		}


		[Test]
		public function testConstructor() : void
		{
			mockRepository.replayAll();
			pm = new RecordATransactionPM(recordedTransactionService, envelopeService, vendorService, navigation, logFactory);

			assertThat(pm.vendors, emptyArray());
			assertThat(pm.envelopes, emptyArray());
		}


		[Test]
		public function testPopulateUserSelections() : void
		{
			Expect.call(envelopeService.listCurrentEnvelopes(null)).ignoreArguments().doAction(function simulateListCurrentEnvelopes(listToPopulate : IList) : void
			{
				listToPopulate.addItem(envelope1);
				listToPopulate.addItem(envelope2);
			});

			Expect.call(vendorService.listVendors(null)).ignoreArguments().doAction(function simulateListVendors(listToPopulate : IList) : void
			{
				listToPopulate.addItem(vendor1);
				listToPopulate.addItem(vendor2);
			});

			mockRepository.replayAll();

			pm = new RecordATransactionPM(recordedTransactionService, envelopeService, vendorService, navigation, logFactory);


			pm.populateUserSelections();

			mockRepository.verifyAll();

			assertThat(pm.envelopes, arrayWithSize(2));
			assertThat(pm.envelopes, everyItem(isA(Envelope)));
			assertThat(pm.envelopes, hasItems(equalTo(envelope1), equalTo(envelope2)));

			assertThat(pm.vendors, arrayWithSize(2));
			assertThat(pm.vendors, everyItem(isA(Vendor)));
			assertThat(pm.vendors, hasItems(equalTo(vendor1), equalTo(vendor2)));
		}


		[Test]
		public function testRecordTransactionVendorExists() : void
		{
			setUpForRecordTransaction();

			var recordedTransaction : RecordedTransaction = createMockRecordedTransaction(transactionNameFixture, transactionDateFixture, transactionAmountFixture);

			Expect.call(recordedTransactionService.addRecordedTransaction(null, null, null, null, null, null)).constraints([envelopeConstraint, transactionNameConstraint, transactionAmountConstraint, vendorConstraint, dateConstraint, resultHolderConstraint]).doAction(function simulateAddRecordedTransaction(envelope : Envelope, transactionName : String, transactionAmount : Money, vendor : Vendor, transactionDate : Date, listToPopulate : IList) : void
			{
				listToPopulate.addItem(recordedTransaction);
			});
			Expect.call(navigation.showRecordedTransactionsView());
			mockRepository.replayAll();
			pm = new RecordATransactionPM(recordedTransactionService, envelopeService, vendorService, navigation, logFactory);
			pm.recordedTransactions = new ArrayCollection(); // normally by injection
			pm.vendors.addItem(vendor1);
			pm.vendors.addItem(vendor2);

			pm.recordTransaction(envelope1, transactionNameFixture, "45.00", vendor2, null, transactionDateFixture);

			mockRepository.verifyAll();


			assertThat(pm.recordedTransactions, arrayWithSize(1));
			assertThat(pm.recordedTransactions, hasItem(equalTo(recordedTransaction)));
			assertThat(pm.vendors, arrayWithSize(2));
		}


		[Test]
		public function testRecordTransactionVendorProposalExists() : void
		{
			setUpForRecordTransaction();

			var recordedTransaction : RecordedTransaction = createMockRecordedTransaction(transactionNameFixture, transactionDateFixture, transactionAmountFixture);

			Expect.call(recordedTransactionService.addRecordedTransaction(null, null, null, null, null, null)).constraints([envelopeConstraint, transactionNameConstraint, transactionAmountConstraint, vendorConstraint, dateConstraint, resultHolderConstraint]).doAction(function simulateAddRecordedTransaction(envelope : Envelope, transactionName : String, transactionAmount : Money, vendor : Vendor, transactionDate : Date, listToPopulate : IList) : void
			{
				listToPopulate.addItem(recordedTransaction);
			});
			Expect.call(navigation.showRecordedTransactionsView());
			mockRepository.replayAll();
			pm = new RecordATransactionPM(recordedTransactionService, envelopeService, vendorService, navigation, logFactory);
			pm.recordedTransactions = new ArrayCollection(); // normally by injection
			pm.vendors.addItem(vendor1);
			pm.vendors.addItem(vendor2);

			pm.recordTransaction(envelope1, transactionNameFixture, "45.00", null, "Tescos", transactionDateFixture);

			mockRepository.verifyAll();


			assertThat(pm.recordedTransactions, arrayWithSize(1));
			assertThat(pm.recordedTransactions, hasItem(equalTo(recordedTransaction)));
			assertThat(pm.vendors, arrayWithSize(2));
		}


		[Test]
		public function testRecordTransactionVendorProposalDoesNotExist() : void
		{
			setUpForRecordTransaction();

			var recordedTransaction : RecordedTransaction = createMockRecordedTransaction(transactionNameFixture, transactionDateFixture, transactionAmountFixture);

			var vendorResultHolderConstraint : AbstractConstraint = new And([Is.typeOf(IList), Property.value("length", 2)])
			vendorNameConstraint = Is.equal("Walmart");

			var constraints : Array = [envelopeConstraint, transactionNameConstraint, transactionAmountConstraint, vendorNameConstraint, dateConstraint, resultHolderConstraint, vendorResultHolderConstraint];

			Expect.call(recordedTransactionService.addRecordedTransactionAndVendor(null, null, null, null, null, null, null)).constraints(constraints).doAction(function simulateAddRecordedTransactionAndVendor(envelope : Envelope, transactionName : String, transactionAmount : Money, vendorName : String, transactionDate : Date, recordedTransactionListToPopulate : IList, vendorListToPopulate : IList) : void
			{
				vendorListToPopulate.addItem(vendor3);
				recordedTransactionListToPopulate.addItem(recordedTransaction);

			});

			Expect.call(navigation.showRecordedTransactionsView());
			mockRepository.replayAll();
			pm = new RecordATransactionPM(recordedTransactionService, envelopeService, vendorService, navigation, logFactory);
			pm.recordedTransactions = new ArrayCollection(); // normally by injection
			pm.vendors.addItem(vendor1);
			pm.vendors.addItem(vendor2);

			pm.recordTransaction(envelope1, transactionNameFixture, "45.00", null, "Walmart", transactionDateFixture);

			mockRepository.verifyAll();


			assertThat(pm.recordedTransactions, arrayWithSize(1));
			assertThat(pm.recordedTransactions, hasItem(equalTo(recordedTransaction)));
			assertThat(pm.vendors, arrayWithSize(3));
		}


		private function createMockRecordedTransaction(transactionName : String, transactionDate : Date, amount : Money) : RecordedTransaction
		{
			var recordedTransaction : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
			SetupResult.forCall(recordedTransaction.amount).returnValue(amount);
			SetupResult.forCall(recordedTransaction.date).returnValue(transactionDate);
			SetupResult.forCall(recordedTransaction.envelope).returnValue(envelope1);
			SetupResult.forCall(recordedTransaction.id).returnValue(3);
			SetupResult.forCall(recordedTransaction.name).returnValue(transactionName);
			SetupResult.forCall(recordedTransaction.vendor).returnValue(vendor2);
			return recordedTransaction;
		}


		private function setUpVendors() : void
		{
			vendor1 = Vendor(mockRepository.createStrict(Vendor));
			SetupResult.forCall(vendor1.name).returnValue("Sainsburys");

			vendor2 = Vendor(mockRepository.createStrict(Vendor));
			SetupResult.forCall(vendor2.name).returnValue("Tescos");

			vendor3 = Vendor(mockRepository.createStrict(Vendor));
			SetupResult.forCall(vendor3.name).returnValue("Walmart");
		}


		private function setUpEnvelopes() : void
		{
			envelope1 = Envelope(mockRepository.createStrict(Envelope));
			SetupResult.forCall(envelope1.name).returnValue("Lunches");
			envelope2 = Envelope(mockRepository.createStrict(Envelope));
			SetupResult.forCall(envelope2.name).returnValue("Dinners");
		}


		private function setUpForRecordTransaction() : void
		{
			setUpRecordTransactionFixtures();
			setUpRecordTransactionFixtureConstraints();
		}


		private function setUpRecordTransactionFixtures() : void
		{

			transactionNameFixture = "Cream Tea";
			transactionDateFixture = new Date();
			transactionAmountFixture = new Money(45.00);
		}


		private function setUpRecordTransactionFixtureConstraints() : void
		{
			envelopeConstraint = Property.value("name", "Lunches");
			transactionNameConstraint = Is.equal(transactionNameFixture);
			transactionAmountConstraint = Property.value("amount", 45);
			dateConstraint = Is.equal(transactionDateFixture);
			resultHolderConstraint = new And([Is.typeOf(IList), Property.value("length", 0)]);
			vendorConstraint = new And([Is.typeOf(Vendor), Property.value("name", "Tescos")]);
			vendorNameConstraint = Is.equal("Tescos");
		}

	}
}
