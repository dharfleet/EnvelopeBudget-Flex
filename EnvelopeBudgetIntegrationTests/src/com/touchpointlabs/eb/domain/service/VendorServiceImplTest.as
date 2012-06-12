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
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.SetupResult;
	import asmock.framework.constraints.Is;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.integration.dao.VendorDao;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import org.flexunit.assertThat;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class VendorServiceImplTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([VendorDao, Vendor, Logger, LogFactory]);


		private var mockRepository : MockRepository;

		private var dao : VendorDao;
		private var logFactory : LogFactory;

		private var service : VendorServiceImpl;

		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			dao = VendorDao(mockRepository.createStrict(VendorDao));
			logFactory = LoggingSupport.mockLoggerForClass(VendorServiceImpl, mockRepository, LoggingSupport.LOG_LEVEL_DEBUG, true);
		}


		[Test]
		public function testCreateVendor() : void
		{
			var vendor : Vendor = Vendor(mockRepository.createStrict(Vendor));
			var vendorNameFixture : String = "W Hotel";

			SetupResult.forCall(vendor.name).returnValue(vendorNameFixture);

			Expect.call(dao.create(null, null)).constraints([Is.equal(vendorNameFixture), Is.typeOf(IList)]).doAction(function simulateResult(vendorName : String, listToPopulate : IList) : void
			{
				listToPopulate.addItem(vendor);
			});


			mockRepository.replayAll();
			service = new VendorServiceImpl(dao, logFactory);


			var resultList : IList = new ArrayCollection();

			service.createVendor(vendorNameFixture, resultList);

			assertThat(resultList, arrayWithSize(1));
			assertThat(resultList, everyItem(isA(Vendor)));
			assertThat(resultList, hasItem(equalTo(vendor)));
			assertThat(Vendor(resultList.getItemAt(0)).name, equalTo(vendorNameFixture));

			mockRepository.verifyAll();
		}


		[Test]
		public function testListVendors() : void
		{
			var vendor1 : Vendor = Vendor(mockRepository.createStrict(Vendor));
			var vendor2 : Vendor = Vendor(mockRepository.createStrict(Vendor));
			var vendor3 : Vendor = Vendor(mockRepository.createStrict(Vendor));

			var all : IList = new ArrayCollection([vendor1, vendor2, vendor3]);

			Expect.call(dao.findAll(null)).ignoreArguments().doAction(function(listToPopulate : IList) : void
			{
				for each (var vendor : Vendor in all)
				{
					listToPopulate.addItem(vendor);
				}
			});

			mockRepository.replayAll();
			service = new VendorServiceImpl(dao, logFactory);

			var results : IList = new ArrayCollection();
			service.listVendors(results);

			assertThat(results, arrayWithSize(3));
			assertThat(results, hasItems(equalTo(vendor1), equalTo(vendor2), equalTo(vendor3)));

			mockRepository.verifyAll();
		}

	}
}
