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
	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.domain.vo.Money;

	import mx.collections.IList;


	/**
	 * A data access object which gives access to the persistance mechanism
	 */
	public interface RecordedTransactionDao
	{

		/**
		 * creates a transaction for the given envelope
		 * @param envelope to associate with the transaction(one envelope has many transactions)
		 * @param transactionName the user given name of the transaction, for example 'A cup of coffee'. 'paid July Bill', etc
		 * @param transactionAmount the value of the transaction
		 * @param vendor associated with this transaction, for example 'Novotel Brisbane'
		 * @param transactionDate the date the transaction occured, NOT the date of this method being called
		 * @return a recorded transaction with the unique id populated
		 */
		function create(envelope : Envelope, transactionName : String, transactionAmount : Money, vendor : Vendor, transactionDate : Date, listToPopulate : IList) : void;


		/**
		 * creates a transaction for the given envelope
		 * @param envelope to associate with the transaction(one envelope has many transactions)
		 * @param transactionName the user given name of the transaction, for example 'A cup of coffee'. 'paid July Bill', etc
		 * @param transactionAmount the value of the transaction
		 * @param vendorName associated with this transaction, for example 'Novotel Brisbane' (will create a vendor with given name)
		 * @param transactionDate the date the transaction occured, NOT the date of this method being called
		 * @return a recorded transaction with the unique id populated
		 */
		function createTransactionAndVendor(envelope : Envelope, transactionName : String, transactionAmount : Money, vendorName : String, transactionDate : Date, recordedTransactionListToPopulate : IList, vendorListToPopulate : IList) : void;



		/**
		 * lists all recorded transactions
		 * @param listToPopulate a list which will be populated with the results
		 * <p>
		 * does not distinguish between historical and current envelopes.
		 * Note that the list population may occur asynchronously;
		 */
		function findAll(listToPopulate : IList) : void;
	}
}
