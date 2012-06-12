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
package com.touchpointlabs.eb.domain.entity
{
	import asmock.framework.MockRepository;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.vo.Money;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.date.dateEqual;

	public class OrmRecordedTransactionTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([Envelope, Vendor]);

		private var mockRepository : MockRepository;

		private var transaction : OrmRecordedTransaction;


		[Before]
		public function setUp() : void
		{
			transaction = new OrmRecordedTransaction();
			mockRepository = new MockRepository();
		}


		[After]
		public function tearDown() : void
		{
			transaction = null;
			mockRepository = null;
		}


		[Test]
		public function testAmountProperty() : void
		{
			var money : Money = new Money(13500000.99);
			transaction.amount = money;
			assertEquals("the money amount should be the same as the amount set", money.amount, transaction.amount.amount);
		}


		[Test]
		public function testAmountValueProperty() : void
		{
			var amount : Number = 13500000.99;
			transaction.amountValue = amount
			assertEquals("the money amount should be the same as the amount set", amount, transaction.amount.amount);
		}


		[Test]
		public function testDateProperty() : void
		{
			var date : Date = new Date();
			transaction.date = date;
			assertThat("the date got should be the same as the date set", transaction.date, dateEqual(date));
		}


		[Test]
		public function testIdProperty() : void
		{
			transaction.id = 2;
			assertEquals("the id got should be the same as that set", 2, transaction.id);
		}


		[Test]
		public function testNameProperty() : void
		{
			var name : String = "Lunch at the Slanted Door";
			transaction.name = name;
			assertEquals("the name got should be the same as that set", name, transaction.name);
		}


		[Test]
		public function testEnvelopeRelationship() : void
		{
			var envelope : Envelope = Envelope(mockRepository.createStrict(Envelope));
			transaction.envelope = envelope;
			assertEquals("the envelope should be the same one which was set", envelope, transaction.envelope);
		}


		[Test]
		public function testVendorRelationship() : void
		{
			var vendor : Vendor = Vendor(mockRepository.createStrict(Vendor));
			transaction.vendor = vendor;
			assertEquals("the vendor shoudl be the same on which was set", vendor, transaction.vendor);
		}

	}
}
