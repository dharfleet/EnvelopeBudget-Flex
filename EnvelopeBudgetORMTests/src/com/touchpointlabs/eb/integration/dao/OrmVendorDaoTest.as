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
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.constraints.Is;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.OrmVendor;
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import nz.co.codec.flexorm.IEntityManager;

	import org.flexunit.assertThat;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class OrmVendorDaoTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([IEntityManager, Vendor, Logger, LogFactory]);

		private var mockRepository : MockRepository;
		private var entityManager : IEntityManager;
		private var findAllResults : IList;
		private var vendor1 : Vendor;
		private var vendor2 : Vendor;
		private var vendor3 : Vendor;
		private var logFactory : LogFactory;

		private var dao : VendorDao;

		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			vendor1 = Vendor(mockRepository.createStrict(Vendor));
			vendor2 = Vendor(mockRepository.createStrict(Vendor));
			vendor3 = Vendor(mockRepository.createStrict(Vendor));
			findAllResults = new ArrayCollection([vendor1, vendor2, vendor3]);
			entityManager = IEntityManager(mockRepository.createStrict(IEntityManager));
			logFactory = LoggingSupport.mockLoggerForClass(OrmVendorDao, mockRepository, LoggingSupport.LOG_LEVEL_DEBUG, true);
		}


		[Test]
		public function testCreate() : void
		{
			Expect.call(entityManager.save(null)).constraints([Is.typeOf(OrmVendor)]).returnValue(33);
			Expect.call(entityManager.load(null, -99)).constraints([Is.typeOf(Class), Is.equal(33)]).returnValue(vendor2);

			mockRepository.replayAll();
			dao = new OrmVendorDao(entityManager, logFactory);

			var resultList : IList = new ArrayCollection();

			dao.create("ITunes", resultList);

			mockRepository.verifyAll();

			assertThat(resultList, arrayWithSize(1));
			assertThat(resultList, everyItem(isA(Vendor)));
			assertThat(resultList.getItemAt(0), equalTo(vendor2));

		}


		[Test]
		public function testFindAll() : void
		{
			Expect.call(entityManager.findAll(OrmVendor)).returnValue(findAllResults);

			mockRepository.replayAll();
			dao = new OrmVendorDao(entityManager, logFactory);

			var results : IList = new ArrayCollection();
			dao.findAll(results);

			mockRepository.verifyAll();

			assertThat(results, arrayWithSize(3));
			assertThat(results, hasItems(equalTo(vendor1), equalTo(vendor2), equalTo(vendor3)));
		}
	}
}
