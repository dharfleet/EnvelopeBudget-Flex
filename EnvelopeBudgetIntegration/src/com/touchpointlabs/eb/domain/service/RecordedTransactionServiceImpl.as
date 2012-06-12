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
	import com.touchpointlabs.eb.integration.dao.RecordedTransactionDao;
	import com.touchpointlabs.logging.LogFactory;

	import mx.collections.IList;


	public class RecordedTransactionServiceImpl extends Service implements RecordedTransactionService
	{

		/**
		 * @param recordedTransactionDAO the data access object class which gives access to the recorded transactions persistance mechanism
		 * @param recordedTransactionDAO the data access object class which gives access to the envelope persistance mechanism
		 */
		public function RecordedTransactionServiceImpl(recordedTransactionDAO : RecordedTransactionDao, logFactory : LogFactory)
		{
			super(logFactory.getLogger(RecordedTransactionServiceImpl));
			this.recordedTransactionDAO = recordedTransactionDAO;
		}


		/**
		 * @see RecordedTransactionService
		 */
		public function addRecordedTransaction(envelope : Envelope, transactionName : String, transactionAmount : Money, vendor : Vendor, transactionDate : Date, listToPopulate : IList) : void
		{
			recordedTransactionDAO.create(envelope, transactionName, transactionAmount, vendor, transactionDate, listToPopulate);
		}


		/**
		 * @see RecordedTransactionService
		 */
		public function addRecordedTransactionAndVendor(envelope : Envelope, transactionName : String, transactionAmount : Money, vendorName : String, transactionDate : Date, recordedTransactionListToPopulate : IList, vendorListToPopulate : IList) : void
		{
			recordedTransactionDAO.createTransactionAndVendor(envelope, transactionName, transactionAmount, vendorName, transactionDate, recordedTransactionListToPopulate, vendorListToPopulate);
		}


		/**
		 * @see RecordedTransactionService
		 */
		public function listTransactions(listToPopulate : IList) : void
		{
			recordedTransactionDAO.findAll(listToPopulate);
		}


		private var recordedTransactionDAO : RecordedTransactionDao;
	}
}
