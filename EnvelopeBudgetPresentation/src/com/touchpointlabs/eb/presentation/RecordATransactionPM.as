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
package com.touchpointlabs.eb.presentation
{
	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.domain.service.EnvelopeService;
	import com.touchpointlabs.eb.domain.service.RecordedTransactionService;
	import com.touchpointlabs.eb.domain.service.VendorService;
	import com.touchpointlabs.eb.domain.vo.Money;
	import com.touchpointlabs.eb.presentation.navigation.Navigation;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;


	public class RecordATransactionPM
	{
		public function RecordATransactionPM(recordedTransactionService : RecordedTransactionService, envelopeService : EnvelopeService, vendorService : VendorService, navigation : Navigation, logFactory : LogFactory)
		{
			this.recordedTransactionService = recordedTransactionService;
			this.envelopeService = envelopeService;
			this.vendorService = vendorService;
			this.navigation = navigation;
			this.log = logFactory.getLogger(RecordATransactionPM);

			this.envelopes = new ArrayCollection();
			this.vendorMap = new Object();
			this.vendors = new ArrayCollection();
			this.vendors.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
		}

		[Bindable]
		public var envelopes : IList;


		[Bindable]
		public var vendors : IList;


		[Inject(id = "recordedTransactions")]
		[Bindable]
		public var recordedTransactions : IList;


		public function recordTransaction(envelope : Envelope, transactionName : String, transactionAmountText : String, vendor : Vendor, vendorProposal : String, transactionDate : Date) : void
		{
			var transactionAmount : Money = new Money(new Number(transactionAmountText));

			if (vendor != null)
			{
				log.debug("the given vendor exists - use the vendor");
				recordedTransactionService.addRecordedTransaction(envelope, transactionName, transactionAmount, vendor, transactionDate, recordedTransactions);
			}
			else if (vendorExists(vendorProposal))
			{
				log.debug("the given vendor name matches an existing vendor - use the vendor with that name");
				var alreadyHeldVendor : Vendor = getVendor(vendorProposal);
				recordedTransactionService.addRecordedTransaction(envelope, transactionName, transactionAmount, alreadyHeldVendor, transactionDate, recordedTransactions);
			}
			else
			{
				log.debug("the vendor doesn't previously exists - create the vendor");
				recordedTransactionService.addRecordedTransactionAndVendor(envelope, transactionName, transactionAmount, vendorProposal, transactionDate, recordedTransactions, vendors);
			}
			navigation.showRecordedTransactionsView();
		}


		public function populateUserSelections() : void
		{
			populateEnvelopes();
			populateVendors();
		}


		protected function populateEnvelopes() : void
		{
			envelopeService.listCurrentEnvelopes(envelopes);
		}


		protected function populateVendors() : void
		{
			log.debug("populateVendors");

			vendorService.listVendors(vendors);
		}


		private function onCollectionChange(event : CollectionEvent) : void
		{
			if (event.kind == CollectionEventKind.ADD)
			{
				for each (var addedVendor : Vendor in event.items)
				{
					addVendorToMap(addedVendor);
				}
			}
			else if (event.kind == CollectionEventKind.REMOVE)
			{
				for each (var removedVendor : Vendor in event.items)
				{
					removeVendorFromMap(removedVendor);
				}
			}
		}


		private function addVendorToMap(vendor : Vendor) : void
		{
			log.debug("addVendorToMap: Vendor with name: {0}", vendor.name);
			vendorMap[vendorNameAsKey(vendor.name)] = vendor;
		}


		private function removeVendorFromMap(vendor : Vendor) : void
		{
			log.debug("removeVendorFromMap: Vendor with name: {0}", vendor.name);
			vendorMap[vendorNameAsKey(vendor.name)] = null;
		}


		private function vendorExists(vendorName : String) : Boolean
		{
			return (vendorMap[vendorNameAsKey(vendorName)] != null);
		}


		private function getVendor(vendorName : String) : Vendor
		{
			return vendorMap[vendorNameAsKey(vendorName)];
		}


		private function vendorNameAsKey(vendorName : String) : String
		{
			return vendorName.toUpperCase();
		}


		private var recordedTransactionService : RecordedTransactionService;
		private var envelopeService : EnvelopeService;
		private var vendorService : VendorService;
		private var vendorMap : Object;
		private var navigation : Navigation;
		public var log : Logger;
	}
}
