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
	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.domain.vo.Money;

	import mx.collections.IList;


	/**
	 * domain services primarily relating to RecordedTransactions
	 */
	public interface RecordedTransactionService
	{

		/**
		 * adds a transaction which is recorded against the given Envelope
		 * @param envelope to record the transaction against
		 * @param transactionName the user given name/description of the transaaction
		 * @param transactionAmount the amount of the transaction expressed as a Money value object
		 * @param vendor the transaction occured with
		 * @param transactionDate the date the transaction occured, NOT the date of this method being called
		 */
		function addRecordedTransaction(envelope : Envelope, transactionName : String, transactionAmount : Money, vendor : Vendor, transactionDate : Date, listToPopulate : IList) : void;



		/**
		 * adds a transaction which is recorded against the given Envelope
		 * @param envelope to record the transaction against
		 * @param transactionName the user given name/description of the transaaction
		 * @param transactionAmount the amount of the transaction expressed as a Money value object
		 * @param vendorName the transaction occured with (will create a vendor with this name)
		 * @param transactionDate the date the transaction occured, NOT the date of this method being called
		 */
		function addRecordedTransactionAndVendor(envelope : Envelope, transactionName : String, transactionAmount : Money, vendorName : String, transactionDate : Date, recordedTransactionListToPopulate : IList, vendorListToPopulate : IList) : void;


		/**
		 * lists all transactions
		 * @param listToPopulate the IList which will be populated with transactions
		 * <p>
		 * all transactions are listed, including those against historical envelopes.
		 * Note, if the listToPopulate paramater is not supplied with a zero length list
		 * no gaurentee can be given if the existing items in that list will or will not be removed
		 */
		function listTransactions(listToPopulate : IList) : void;

	}
}
