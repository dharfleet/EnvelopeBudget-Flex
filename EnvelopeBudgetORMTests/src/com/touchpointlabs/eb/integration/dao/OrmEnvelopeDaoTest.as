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
	import asmock.framework.SetupResult;
	import asmock.framework.constraints.And;
	import asmock.framework.constraints.Is;
	import asmock.framework.constraints.Property;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.OrmEnvelope;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import nz.co.codec.flexorm.IEntityManager;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.object.equalTo;

	public class OrmEnvelopeDaoTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([IEntityManager, Envelope, OrmEnvelope, Logger, LogFactory]);


		private var mockRepository : MockRepository;

		private var entityManager : IEntityManager;
		private var envelopeList : IList;
		private var envelopeDefault : OrmEnvelope;
		private var envelope2 : Envelope;
		private var envelope3 : Envelope;
		private var logFactory : LogFactory;

		private var dao : OrmEnvelopeDao;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();

			entityManager = IEntityManager(mockRepository.createStrict(IEntityManager));


			setUpEnvelopeFixtures();

			var initialList : IList = new ArrayCollection();

			mockRepository.ordered(function() : void
			{

				Expect.call(entityManager.findAll(null)).constraints([Is.typeOf(Class)]).returnValue(initialList).repeat.once().message("findAll should be called once during constructor");

				Expect.call(entityManager.save(envelopeDefault)).constraints([new And([Is.typeOf(OrmEnvelope), Property.value("name", "Default")])]).returnValue(1).message("the constructor should be creating a default envelope");

				Expect.call(entityManager.load(null, -99)).constraints([Is.typeOf(Class), Is.equal(1)]).returnValue(envelopeDefault).message("the contstructor should be loading the default envelope and putting it in the internal list");

			});
			logFactory = LoggingSupport.mockLoggerForClass(OrmEnvelopeDao, mockRepository, LoggingSupport.LOG_LEVEL_DEBUG, true);
		}


		private function setUpEnvelopeFixtures() : void
		{

			envelopeDefault = new OrmEnvelope();
			envelopeDefault.name = "Default";
			envelope2 = Envelope(mockRepository.createStrict(Envelope));
			envelope3 = Envelope(mockRepository.createStrict(Envelope));
			envelopeList = new ArrayCollection([envelopeDefault, envelope2, envelope3]);
		}


		[Test]
		public function testFindAll() : void
		{

			Expect.call(entityManager.findAll(null)).constraints([Is.typeOf(Class)]).message("findAll should be called on the entity manager").returnValue(envelopeList);


			mockRepository.replayAll();

			dao = new OrmEnvelopeDao(entityManager, envelopeDefault, logFactory);

			var results : IList = new ArrayCollection();
			dao.findAll(results);

			mockRepository.verifyAll();

			assertThat(results, arrayWithSize(3));
			assertThat(results, hasItems(equalTo(envelopeDefault), equalTo(envelope2), equalTo(envelope3)));
			assertTrue(true);
		}


		[Test]
		public function testCreate() : void
		{
			var envelopeName : String = "Entertainment";
			var generatedId : int = 23;

			Expect.call(entityManager.save(null)).ignoreArguments().constraints([new And([Is.typeOf(OrmEnvelope), Property.value("name", envelopeName)])]).returnValue(generatedId).message("the entity manager should save the envelope");


			var savedEnvelope : Envelope = Envelope(mockRepository.createStrict(Envelope));
			SetupResult.forCall(savedEnvelope.id).returnValue(generatedId);
			SetupResult.forCall(savedEnvelope.name).returnValue(envelopeName);

			Expect.call(entityManager.load(null, -99)).constraints([Is.typeOf(Class), Is.equal(generatedId)]).returnValue(savedEnvelope);



			mockRepository.replayAll();

			dao = new OrmEnvelopeDao(entityManager, envelopeDefault, logFactory);

			var result : Envelope = dao.create(envelopeName);

			mockRepository.verifyAll();
		}

	}
}
