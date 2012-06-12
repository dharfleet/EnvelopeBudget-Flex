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

	[Table(name = "RECORDED_TRANSACTION")]
	[Bindable]
	public class OrmRecordedTransaction implements RecordedTransaction
	{

		public function get id() : int
		{
			return _id;
		}

		[Id]
		public function set id(id : int) : void
		{
			_id = id;
		}


		public function get date() : Date
		{
			return _date;
		}

		public function set date(value : Date) : void
		{
			_date = value;
		}


		public function get name() : String
		{
			return _name;
		}

		public function set name(value : String) : void
		{
			_name = value;
		}


		public function get amount() : Money
		{
			return _amount;
		}

		[Transient]
		public function set amount(amount : Money) : void
		{
			_amount = amount;
			_amountValue = amount.amount;
		}


		// note that this is currently a hack because Flex ORM does not allow for complex types with a one to one relationship
		public function get amountValue() : Number
		{
			return _amountValue;
		}

		// Note, this is currently a hack because Flex ORM does not seem to allow for complex types with a one to one relationship
		[Column(name = "amount")]
		public function set amountValue(value : Number) : void
		{
			_amountValue = value;
			_amount = new Money(value);
		}


		public function get envelope() : Envelope
		{
			return this._envelope;
		}

		// Note, the attribute 'type' defined below is not part of the Flex ORM spec, Flex ORM has been
		// refactored by author to allow this type specification to deal with use of Entity interfaces
		// as parameters. The 'type' param refers to the concrete implementation of the given Entity.

		[ManyToOne(cascade = "save-update", type = "com.touchpointlabs.eb.domain.entity.OrmEnvelope")]
		public function set envelope(value : Envelope) : void
		{
			this._envelope = value;
		}


		public function get vendor() : Vendor
		{
			return this._vendor;
		}

		[ManyToOne(cascade = "save-update", type = "com.touchpointlabs.eb.domain.entity.OrmVendor")]
		public function set vendor(value : Vendor) : void
		{
			this._vendor = value;
		}


		private var _id : int;
		private var _date : Date;
		private var _name : String;
		private var _amount : Money;
		private var _amountValue : Number;

		private var _envelope : Envelope;
		private var _vendor : Vendor;
	}
}
