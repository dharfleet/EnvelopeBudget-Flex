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
	import com.touchpointlabs.collections.ListUtils;
	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.OrmRecordedTransaction;
	import com.touchpointlabs.eb.domain.entity.RecordedTransaction;
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.domain.vo.Money;
	import com.touchpointlabs.logging.LogFactory;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import nz.co.codec.flexorm.IEntityManager;


	public class OrmRecordedTransactionDao extends OrmDao implements RecordedTransactionDao
	{

		public function OrmRecordedTransactionDao(entityManager : IEntityManager, logFactory : LogFactory, vendorDao : VendorDao)
		{
			super(entityManager, logFactory.getLogger(OrmRecordedTransactionDao));
			this.vendorDao = vendorDao;
		}


		public function create(envelope : Envelope, transactionName : String, transactionAmount : Money, vendor : Vendor, transactionDate : Date, listToPopulate : IList) : void
		{
			var transaction : OrmRecordedTransaction = new OrmRecordedTransaction();
			transaction.name = transactionName;
			transaction.amount = transactionAmount;
			transaction.date = transactionDate;
			transaction.envelope = envelope;
			transaction.vendor = vendor;

			log.prettyPrintObjectIfDebugEnabled(transaction, "created a transaction ready for saving");

			var id : int = entityManager.save(transaction);

			log.debug("entity manager reports saved transaction id as: {0}", id);

			var persistedTransaction : RecordedTransaction = OrmRecordedTransaction(entityManager.load(OrmRecordedTransaction, id));

			log.prettyPrintObjectIfDebugEnabled(persistedTransaction, "Persisted Transaction");

			listToPopulate.addItem(persistedTransaction);
		}


		public function createTransactionAndVendor(envelope : Envelope, transactionName : String, transactionAmount : Money, vendorName : String, transactionDate : Date, recordedTransactionListToPopulate : IList, vendorListToPopulate : IList) : void
		{
			var vendors : IList = new ArrayCollection();
			vendorDao.create(vendorName, vendors);
			var vendor : Vendor = Vendor(vendors.getItemAt(0));
			vendorListToPopulate.addItem(vendor);

			return create(envelope, transactionName, transactionAmount, vendor, transactionDate, recordedTransactionListToPopulate);
		}


		public function findAll(listToPopulate : IList) : void
		{
			var all : IList = entityManager.findAll(OrmRecordedTransaction);
			log.debug("found {0} OrmRecordedTransactions", all.length);

			ListUtils.merge(all, listToPopulate, "id");
		}


		private var vendorDao : VendorDao;

	}
}
