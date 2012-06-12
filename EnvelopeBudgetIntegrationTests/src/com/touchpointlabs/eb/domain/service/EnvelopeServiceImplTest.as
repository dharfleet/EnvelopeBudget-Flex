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
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.integration.dao.EnvelopeDao;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.object.equalTo;

	public class EnvelopeServiceImplTest
	{
		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([EnvelopeDao, Envelope, Logger, LogFactory]);


		private var mockRepository : MockRepository;

		private var dao : EnvelopeDao;
		private var logFactory : LogFactory;

		private var service : EnvelopeService;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			dao = EnvelopeDao(mockRepository.createStrict(EnvelopeDao));
			logFactory = LoggingSupport.mockLoggerForClass(EnvelopeServiceImpl, mockRepository, LoggingSupport.LOG_LEVEL_DEBUG, true);
		}


		[Test]
		public function testListCurrentEnvelopes() : void
		{
			var envelope1 : Envelope = Envelope(mockRepository.createStrict(Envelope));
			var envelope2 : Envelope = Envelope(mockRepository.createStrict(Envelope));
			var envelope3 : Envelope = Envelope(mockRepository.createStrict(Envelope));
			var currentEnvelopes : IList = new ArrayCollection([envelope1, envelope2, envelope3]);

			Expect.call(dao.findAll(null)).ignoreArguments().doAction(function(listToPopulate : IList) : void
			{
				for each (var envelope : Envelope in currentEnvelopes)
				{
					listToPopulate.addItem(envelope);
				}
			});

			var listToPopulate : IList = new ArrayCollection();

			mockRepository.replayAll();

			service = new EnvelopeServiceImpl(dao, logFactory);

			service.listCurrentEnvelopes(listToPopulate);

			assertThat(listToPopulate, arrayWithSize(3));
			assertThat(listToPopulate, hasItems(equalTo(envelope1), equalTo(envelope2), equalTo(envelope3)));

			mockRepository.verifyAll();
		}
	}
}
