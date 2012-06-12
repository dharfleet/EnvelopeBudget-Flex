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
	import com.touchpointlabs.eb.domain.vo.Money;
	import com.touchpointlabs.sforce.rest.date.SalesforceDateTranslator;

	public class SalesforceRecordedTransaction implements RecordedTransaction
	{
		public function SalesforceRecordedTransaction(jsonRecord : Object)
		{
			this._id = jsonRecord.recordedTransactionId__c;
			this._sfid = jsonRecord.Id;
			this._name = jsonRecord.Name;
			this._amount = new Money(jsonRecord.amount__c);
			this._date = SalesforceDateTranslator.fromISO8601(jsonRecord.date__c);
			this._vendor = new SalesforceVendor(jsonRecord.vendor__r);
			this._envelope = new SalesforceEnvelope(jsonRecord.envelope__r);
		}


		public function get id() : int
		{
			return _id;
		}


		/** the force.com Id */
		public function get sfid() : String
		{
			return _sfid;
		}

		public function get name() : String
		{
			return _name;
		}

		public function get amount() : Money
		{
			return _amount;
		}

		public function get date() : Date
		{
			return _date;
		}

		public function get envelope() : Envelope
		{
			return _envelope;
		}

		public function get vendor() : Vendor
		{
			return _vendor;
		}


		private var _id : int;
		private var _sfid : String;
		private var _name : String;
		private var _amount : Money;
		private var _date : Date;

		private var _envelope : Envelope;
		private var _vendor : Vendor;

	}
}
