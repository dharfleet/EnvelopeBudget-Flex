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
package com.touchpointlabs.eb.integration.dao
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
	import com.touchpointlabs.eb.domain.entity.OrmRecordedTransaction;
	import com.touchpointlabs.eb.domain.entity.RecordedTransaction;
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.domain.vo.Money;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import nz.co.codec.flexorm.IEntityManager;

	import org.flexunit.assertThat;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class OrmRecordedTransactionDaoTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([IEntityManager, Envelope, Vendor, RecordedTransaction, OrmRecordedTransaction, Logger, LogFactory, VendorDao]);


		private var mockRepository : MockRepository = new MockRepository();

		private var entityManager : nz.co.codec.flexorm.IEntityManager;
		private var transaction : RecordedTransaction;
		private var logFactory : LogFactory;

		private var dao : OrmRecordedTransactionDao;

		[Before]
		public function setUp() : void
		{
			entityManager = IEntityManager(mockRepository.createStrict(IEntityManager));
			logFactory = LoggingSupport.mockLoggerForClass(OrmRecordedTransactionDao, mockRepository, LoggingSupport.LOG_LEVEL_DEBUG, true)
		}


		[Test]
		public function testFindAll() : void
		{
			var findAllResults : IList = new ArrayCollection();
			var recordedTransaction1 : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
			SetupResult.forCall(recordedTransaction1.id).returnValue(1);
			var recordedTransaction2 : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
			SetupResult.forCall(recordedTransaction2.id).returnValue(2);
			var recordedTransaction3 : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
			SetupResult.forCall(recordedTransaction3.id).returnValue(3);

			findAllResults.addItem(recordedTransaction1);
			findAllResults.addItem(recordedTransaction2);
			findAllResults.addItem(recordedTransaction3);

			Expect.call(entityManager.findAll(null)).constraints([Is.typeOf(Class)]).returnValue(findAllResults);

			var vendorDao : VendorDao = VendorDao(mockRepository.createStrict(VendorDao));

			mockRepository.replayAll();
			dao = new OrmRecordedTransactionDao(entityManager, logFactory, vendorDao);

			var results : IList = new ArrayCollection();
			dao.findAll(results);

			mockRepository.verifyAll();

			assertThat(results, arrayWithSize(3));
			assertThat(results, hasItems(equalTo(recordedTransaction1), equalTo(recordedTransaction2), equalTo(recordedTransaction3)));
		}


		[Test]
		public function testCreateTransaction() : void
		{


			var vendorFixture : Vendor = Vendor(mockRepository.createStrict(Vendor));
			var envelopeFixture : Envelope = Envelope(mockRepository.createStrict(Envelope));


			var nameFixture : String = "Singapore Sling at Raffle's";
			var moneyFixture : Money = new Money(25.99);
			var dateOfTransactionFixture : Date = new Date();

			var mockTransactionToReturn : OrmRecordedTransaction = OrmRecordedTransaction(mockRepository.createStrict(OrmRecordedTransaction));

			//reasoning - when the transaction is added to the results list inside the dao, the list starts tracking property change events
			SetupResult.forCall(mockTransactionToReturn.addEventListener(null, null)).ignoreArguments();

			var typeConstraint : AbstractConstraint = Is.typeOf(RecordedTransaction);
			var nameConstraint : AbstractConstraint = Property.value("name", nameFixture);
			var dateConstraint : AbstractConstraint = Property.valueConstraint("date", Is.equal(dateOfTransactionFixture));
			var amountConstraint : AbstractConstraint = Property.valueConstraint("amount", Property.valueConstraint("amount", Is.equal(25.99)));

			Expect.call(entityManager.save(null)).returnValue(1).constraints([new And([typeConstraint, nameConstraint, dateConstraint])]);

			Expect.call(entityManager.load(null, NaN)).constraints([Is.typeOf(Class), Is.equal(1)]).returnValue(mockTransactionToReturn);

			var vendorDao : VendorDao = VendorDao(mockRepository.createStrict(VendorDao));

			mockRepository.replayAll();
			dao = new OrmRecordedTransactionDao(entityManager, logFactory, vendorDao);

			var resultList : IList = new ArrayCollection();

			dao.create(envelopeFixture, nameFixture, moneyFixture, vendorFixture, dateOfTransactionFixture, resultList);

			mockRepository.verifyAll();
			assertThat(resultList, arrayWithSize(1));
			assertThat(resultList, everyItem(isA(RecordedTransaction)));
		}

		[Test]
		public function testCreateTransactionAndVendor() : void
		{
			var vendorFixture : Vendor = Vendor(mockRepository.createStrict(Vendor));
			var vendorNameFixture : String = "Raffles";
			SetupResult.forCall(vendorFixture.name).returnValue(vendorNameFixture);

			var envelopeFixture : Envelope = Envelope(mockRepository.createStrict(Envelope));

			var nameFixture : String = "Singapore Sling";
			var moneyFixture : Money = new Money(25.99);
			var dateOfTransactionFixture : Date = new Date();

			var mockTransactionToReturn : OrmRecordedTransaction = OrmRecordedTransaction(mockRepository.createStrict(OrmRecordedTransaction));

			//reasoning -  when the transaction is added to the results list inside the dao, the list starts tracking property change events
			SetupResult.forCall(mockTransactionToReturn.addEventListener(null, null)).ignoreArguments();

			var typeConstraint : AbstractConstraint = Is.typeOf(RecordedTransaction);
			var nameConstraint : AbstractConstraint = Property.value("name", nameFixture);
			var dateConstraint : AbstractConstraint = Property.valueConstraint("date", Is.equal(dateOfTransactionFixture));
			var amountConstraint : AbstractConstraint = Property.valueConstraint("amount", Property.valueConstraint("amount", Is.equal(25.99)));
			var vendorConstraint : AbstractConstraint = Property.valueConstraint("vendor", Property.value("name", vendorNameFixture));

			Expect.call(entityManager.save(null)).returnValue(1).constraints([new And([typeConstraint, nameConstraint, dateConstraint, amountConstraint, vendorConstraint])]);

			Expect.call(entityManager.load(null, NaN)).constraints([Is.typeOf(Class), Is.equal(1)]).returnValue(mockTransactionToReturn);

			var vendorDao : VendorDao = VendorDao(mockRepository.createStrict(VendorDao));

			Expect.call(vendorDao.create(null, null)).constraints([Is.equal(vendorNameFixture), Is.typeOf(IList)]).doAction(function(vendorName : String, listToPopulate : IList) : void
			{
				listToPopulate.addItem(vendorFixture);
			});

			var transactionResultList : IList = new ArrayCollection();
			var vendorResultList : IList = new ArrayCollection();
			var existingVendor : Vendor = Vendor(mockRepository.createStrict(Vendor));
			SetupResult.forCall(existingVendor.id).returnValue(12);
			SetupResult.forCall(existingVendor.name).returnValue("The W San Francisco");


			mockRepository.replayAll();
			vendorResultList.addItem(existingVendor);


			dao = new OrmRecordedTransactionDao(entityManager, logFactory, vendorDao);

			dao.createTransactionAndVendor(envelopeFixture, nameFixture, moneyFixture, vendorNameFixture, dateOfTransactionFixture, transactionResultList, vendorResultList);


			assertThat(transactionResultList, arrayWithSize(1));
			assertThat(transactionResultList, everyItem(isA(RecordedTransaction)));
			assertThat(transactionResultList.getItemAt(0), equalTo(mockTransactionToReturn));

			assertThat(vendorResultList, arrayWithSize(2));
			assertThat(vendorResultList, everyItem(isA(Vendor)));
			assertThat(vendorResultList, hasItems(equalTo(vendorFixture), equalTo(existingVendor)));


			mockRepository.verifyAll();
		}
	}
}
