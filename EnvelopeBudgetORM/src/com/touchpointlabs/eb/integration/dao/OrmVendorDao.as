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
	import com.touchpointlabs.eb.domain.entity.OrmVendor;
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.logging.LogFactory;

	import mx.collections.IList;

	import nz.co.codec.flexorm.IEntityManager;


	public class OrmVendorDao extends OrmDao implements VendorDao
	{
		public function OrmVendorDao(entityManager : IEntityManager, logFactory : LogFactory)
		{
			super(entityManager, logFactory.getLogger(OrmVendorDao));
		}


		public function create(name : String, listToAddResultTo : IList) : void
		{
			var vendor : OrmVendor = new OrmVendor();
			vendor.name = name;

			log.prettyPrintObjectIfDebugEnabled(vendor, "creating a Vendor");

			var id : int = entityManager.save(vendor);

			log.debug("Vendor saved with id: {0}", id);

			var persistedVendor : Vendor = Vendor(entityManager.load(OrmVendor, id));

			log.prettyPrintObjectIfDebugEnabled(persistedVendor, "Persisted Vendor is");

			listToAddResultTo.addItem(persistedVendor);
		}


		public function findAll(listToPopulate : IList) : void
		{
			var all : IList = entityManager.findAll(OrmVendor);
			log.debug("found {0} Vendors", all.length);

			for (var index : int = 0; index < all.length; index++)
			{
				var vendor : Vendor = Vendor(all.getItemAt(index));
				listToPopulate.addItem(vendor);
			}
		}
	}
}
