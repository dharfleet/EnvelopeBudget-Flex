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
package com.touchpointlabs.eb.domain.service
{
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.SetupResult;
	import asmock.framework.constraints.And;
	import asmock.framework.constraints.Is;
	import asmock.framework.constraints.Property;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.RecordedTransaction;
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.domain.vo.Money;
	import com.touchpointlabs.eb.integration.dao.EnvelopeDao;
	import com.touchpointlabs.eb.integration.dao.RecordedTransactionDao;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import org.flexunit.assertThat;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class RecordedTransactionServiceImplTest
	{
		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([RecordedTransactionDao, EnvelopeDao, RecordedTransaction, Envelope, Vendor]);


		private var service : RecordedTransactionService;

		private var mockRepository : MockRepository;

		private var recordedTransactionDAO : RecordedTransactionDao;
		private var logFactory : LogFactory;

		private var transaction1 : RecordedTransaction;
		private var transaction2 : RecordedTransaction;
		private var transaction3 : RecordedTransaction;

		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();

			recordedTransactionDAO = RecordedTransactionDao(mockRepository.createStrict(RecordedTransactionDao));

			logFactory = LoggingSupport.mockLoggerForClass(RecordedTransactionServiceImpl, mockRepository, LoggingSupport.LOG_LEVEL_DEBUG, true);

			transaction1 = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
			transaction2 = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
			transaction3 = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
		}


		[Test]
		public function testListTransactions() : void
		{
			var findAllResults : IList = new ArrayCollection([transaction1, transaction2, transaction3]);

			Expect.call(recordedTransactionDAO.findAll(null)).ignoreArguments().doAction(function(listToPopulate : IList) : void
			{
				for each (var transaction : RecordedTransaction in findAllResults)
				{
					listToPopulate.addItem(transaction);
				}
			});

			mockRepository.replayAll();

			var listToPopulate : IList = new ArrayCollection();
			service = new RecordedTransactionServiceImpl(recordedTransactionDAO, logFactory);
			service.listTransactions(listToPopulate);

			mockRepository.verifyAll();

			assertThat(listToPopulate, arrayWithSize(3));
			assertThat(listToPopulate, hasItems(equalTo(transaction1), equalTo(transaction2), equalTo(transaction3)));
		}


		[Test]
		public function testAddRecordedTransaction() : void
		{

			var envelopeFixture : Envelope = Envelope(mockRepository.createStrict(Envelope));

			var vendorFixture : Vendor = Vendor(mockRepository.createStrict(Vendor));

			var transactionNameFixture : String = "Weekly Supermarket Shop";
			var transactionAmountFixture : Money = new Money(92.74);
			var transactionDateFixture : Date = new Date(2012, 11, 1);

			var recordedTransaction : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
			SetupResult.forCall(recordedTransaction.amount).returnValue(transactionAmountFixture);
			SetupResult.forCall(recordedTransaction.date).returnValue(transactionDateFixture);
			SetupResult.forCall(recordedTransaction.envelope).returnValue(envelopeFixture);
			SetupResult.forCall(recordedTransaction.id).returnValue(99);
			SetupResult.forCall(recordedTransaction.name).returnValue(transactionNameFixture);
			SetupResult.forCall(recordedTransaction.vendor).returnValue(vendorFixture);


			Expect.call(recordedTransactionDAO.create(null, null, null, null, null, null)).constraints([Is.typeOf(Envelope), Is.equal("Weekly Supermarket Shop"), new And([Property.value("amount", 92.74), Is.typeOf(Money)]), Is.anything(), Is.equal(transactionDateFixture), Is.typeOf(IList)]).doAction(function simulateCreate(envelope : Envelope, transactionName : String, transactionAmount : Money, vendor : Vendor, transactionDate : Date, listToPopulate : IList) : void
			{
				listToPopulate.addItem(recordedTransaction);
			});


			mockRepository.replayAll();

			service = new RecordedTransactionServiceImpl(recordedTransactionDAO, logFactory);

			var resultList : IList = new ArrayCollection();

			service.addRecordedTransaction(envelopeFixture, transactionNameFixture, transactionAmountFixture, vendorFixture, transactionDateFixture, resultList);

			mockRepository.verifyAll();

			assertThat(resultList, arrayWithSize(1));
			assertThat(resultList, everyItem(isA(RecordedTransaction)));
			assertThat(resultList, hasItem(equalTo(recordedTransaction)));

		}

	}
}
