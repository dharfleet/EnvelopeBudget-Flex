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
package com.touchpointlabs.eb.domain.vo
{

	public class Money
	{

		/**
		 * a class to represent an instance of currency
		 * @param amount defaults to Not a Number (NaN)
		 * @param decimalPlaces defaults to 2  for example USD, EUR and GBP all have 2 decimal places
		 * <p>
		 * FUTURE - investigate this more - http://www.fxcomps.com/money.html
		 */
		public function Money(amount : Number=NaN, decimalPlaces : int=2) : void
		{
			this.decimalPlaces = decimalPlaces;
			this.precision = Math.pow(10, decimalPlaces);
			this.amount = amount;
		}


		public function set amount(value : Number) : void
		{
			_amount = (Math.round(value * precision) / precision);
		}


		/**
		 * the currency value represented by a Number
		 */
		public function get amount() : Number
		{
			return _amount;
		}


		private var _amount : Number;
		private var decimalPlaces : int;
		private var precision : Number;
	}
}
// TODO (Future) - investigate this more - http://www.fxcomps.com/money.html
