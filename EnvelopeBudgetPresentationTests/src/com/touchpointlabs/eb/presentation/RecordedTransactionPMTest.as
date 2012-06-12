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
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.RecordedTransaction;
	import com.touchpointlabs.eb.domain.service.RecordedTransactionService;
	import com.touchpointlabs.eb.presentation.navigation.Navigation;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import org.flexunit.assertThat;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.hasItem;

	public class RecordedTransactionPMTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([RecordedTransactionService, Navigation, RecordedTransaction, LogFactory, Logger]);


		private var mockRepository : MockRepository;

		private var service : RecordedTransactionService;
		private var navigation : Navigation;
		private var logFactory : LogFactory;

		private var pm : RecordedTransactionPM;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			service = RecordedTransactionService(mockRepository.createStrict(RecordedTransactionService));
			navigation = Navigation(mockRepository.createStrict(Navigation));
			logFactory = LoggingSupport.mockLoggerForClass(RecordedTransactionPM, mockRepository, LoggingSupport.LOG_LEVEL_DEBUG, true);
		}


		[Test]
		public function testShowNewTransactionInput() : void
		{
			Expect.call(navigation.showRecordATransactionView());
			mockRepository.replayAll();
			pm = new RecordedTransactionPM(service, navigation, logFactory);

			pm.showNewTransactionInput();

			mockRepository.verifyAll();
		}


		[Test]
		public function testRefresh() : void
		{
			var recordedTransactionOld : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));
			var recordedTransactionNew : RecordedTransaction = RecordedTransaction(mockRepository.createStrict(RecordedTransaction));

			Expect.call(service.listTransactions(null)).ignoreArguments().doAction(function simulateServiceListTransactions(listToPopulate : IList) : void
			{
				listToPopulate.addItem(recordedTransactionNew);
			});

			mockRepository.replayAll();
			pm = new RecordedTransactionPM(service, navigation, logFactory);
			pm.recordedTransactions = new ArrayCollection();
			pm.recordedTransactions.addItem(recordedTransactionOld);

			pm.refresh();

			mockRepository.verifyAll();

			assertThat(pm.recordedTransactions, arrayWithSize(2));
			assertThat(pm.recordedTransactions, hasItem(recordedTransactionNew));
			assertThat(pm.recordedTransactions, hasItem(recordedTransactionOld));
		}

	}
}
