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
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.date.dateEqual;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperty;

	public class SalesforceRecordedTransactionTest
	{

		private var transaction : RecordedTransaction;


		[Before]
		public function setUp() : void
		{
			var envelopeJsonRecord : Object = {EnvelopeId__c: "1", Id: "AcAAAdhlhj389.3kl", Name: "Internet Costs"};
			var vendorJsonRecord : Object = {VendorId__c: "1", Id: "AcAAAdhlhj389.3kl", Name: "Starbucks"};
			var transactionJsonRecord : Object = {recordedTransactionId__c: "1", Id: "AcBBB87fefsdfh.dge", Name: "1 Hour Connection", amount__c: "5.95", date__c: "2012-05-27T23:59:45", vendor__r: vendorJsonRecord, envelope__r: envelopeJsonRecord};
			transaction = new SalesforceRecordedTransaction(transactionJsonRecord);
		}


		[After]
		public function tearDown() : void
		{
			transaction = null;
		}


		[Test]
		public function testAmount() : void
		{
			assertThat(transaction.amount, hasProperty("amount", equalTo(5.95)));
		}


		[Test]
		public function testDate() : void
		{
			var expected : Date = new Date(2012, 04, 27, 23, 59, 45);
			assertThat(expected, dateEqual(transaction.date));
		}


		[Test]
		public function testId() : void
		{
			assertEquals(1, transaction.id);
		}


		[Test]
		public function testName() : void
		{
			assertEquals("1 Hour Connection", transaction.name);
		}


		[Test]
		public function testSfid() : void
		{
			assertEquals("AcBBB87fefsdfh.dge", SalesforceRecordedTransaction(transaction).sfid);
		}


		[Test]
		public function testEnvelope() : void
		{
			assertEquals(1, transaction.envelope.id);
			assertEquals("Internet Costs", transaction.envelope.name);
			assertEquals("AcAAAdhlhj389.3kl", SalesforceEnvelope(transaction.envelope).sfid);
		}


		[Test]
		public function testVendor() : void
		{
			assertEquals(1, transaction.vendor.id);
			assertEquals("Starbucks", transaction.vendor.name);
			assertEquals("AcAAAdhlhj389.3kl", SalesforceVendor(transaction.vendor).sfid);
		}
	}
}
