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
package com.touchpointlabs.eb.integration.api.recordedtransactions
{
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.constraints.Is;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.RecordedTransaction;
	import com.touchpointlabs.eb.integration.api.CommandContext;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;
	import com.touchpointlabs.sforce.rest.remote.SoqlQueryRemoteService;
	import com.touchpointlabs.sforce.rest.remote.SoqlQueryResultEvent;

	import mx.collections.IList;

	import org.flexunit.assertThat;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.core.isA;


	public class ListRecordedTransactionsCommandTest
	{
		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([SoqlQueryRemoteService, CommandContext, SalesforceOrg, Logger, LogFactory]);


		private var mockRepository : MockRepository;
		private var remoteService : SoqlQueryRemoteService;
		private var organization : SalesforceOrg;
		private var context : CommandContext;
		private var logFactory : LogFactory;

		private var command : ListRecordedTransactionsCommand;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			logFactory = LoggingSupport.mockLogger();
			remoteService = SoqlQueryRemoteService(mockRepository.createStrict(SoqlQueryRemoteService, [null, logFactory]));
			context = CommandContext(mockRepository.createStrict(CommandContext, [logFactory]));
			organization = SalesforceOrg(mockRepository.createStrict(SalesforceOrg, [null, null, null]));
		}


		[After]
		public function tearDown() : void
		{
			remoteService = null;
			mockRepository = null;
			command = null;
			context = null;
		}


		[Test]
		public function testConstructor() : void
		{
			mockRepository.replay(remoteService);

			command = new ListRecordedTransactionsCommand(remoteService, logFactory);

			mockRepository.verify(remoteService);
		}


		[Test]
		public function testExecute() : void
		{
			var onResultListener : Function;


			var rawHttpResponse : String = "{\"totalSize\":3,\"done\":true,\"records\":[{\"attributes\":{\"type\":\"RecordedTransaction__c\",\"url\":\"/services/data/v24.0/sobjects/RecordedTransaction__c/a08d0000008caehAAA\"},\"recordedTransactionId__c\":\"24\",\"Id\":\"a08d0000008caehAAA\",\"Name\":\"Coffee & Walnut Cake\",\"amount__c\":3.99,\"date__c\":\"2012-05-29T12:49:42.000+0000\",\"envelope__c\":\"a07d0000006cBy1AAE\",\"vendor__c\":\"a06d000000DucQvAAJ\",\"vendor__r\":{\"attributes\":{\"type\":\"Vendor__c\",\"url\":\"/services/data/v24.0/sobjects/Vendor__c/a06d000000DucQvAAJ\"},\"Id\":\"a06d000000DucQvAAJ\",\"Name\":\"Starbucks\",\"VendorId__c\":\"2\"},\"envelope__r\":{\"attributes\":{\"type\":\"Envelope__c\",\"url\":\"/services/data/v24.0/sobjects/Envelope__c/a07d0000006cBy1AAE\"},\"Id\":\"a07d0000006cBy1AAE\",\"Name\":\"Lunches\",\"EnvelopeId__c\":\"1\"}},{\"attributes\":{\"type\":\"RecordedTransaction__c\",\"url\":\"/services/data/v24.0/sobjects/RecordedTransaction__c/a08d0000008cae4AAA\"},\"recordedTransactionId__c\":\"21\",\"Id\":\"a08d0000008cae4AAA\",\"Name\":\"Water\",\"amount__c\":1.0,\"date__c\":\"2012-05-29T12:30:36.000+0000\",\"envelope__c\":\"a07d0000006cBy1AAE\",\"vendor__c\":\"a06d000000DucQvAAJ\",\"vendor__r\":{\"attributes\":{\"type\":\"Vendor__c\",\"url\":\"/services/data/v24.0/sobjects/Vendor__c/a06d000000DucQvAAJ\"},\"Id\":\"a06d000000DucQvAAJ\",\"Name\":\"Starbucks\",\"VendorId__c\":\"2\"},\"envelope__r\":{\"attributes\":{\"type\":\"Envelope__c\",\"url\":\"/services/data/v24.0/sobjects/Envelope__c/a07d0000006cBy1AAE\"},\"Id\":\"a07d0000006cBy1AAE\",\"Name\":\"Lunches\",\"EnvelopeId__c\":\"1\"}},{\"attributes\":{\"type\":\"RecordedTransaction__c\",\"url\":\"/services/data/v24.0/sobjects/RecordedTransaction__c/a08d0000008cvfYAAQ\"},\"recordedTransactionId__c\":\"30\",\"Id\":\"a08d0000008cvfYAAQ\",\"Name\":\"Wagon Wheel\",\"amount__c\":3.5,\"date__c\":\"2012-06-01T14:05:25.000+0000\",\"envelope__c\":\"a07d0000006cBy1AAE\",\"vendor__c\":\"a06d000000EHN4nAAH\",\"vendor__r\":{\"attributes\":{\"type\":\"Vendor__c\",\"url\":\"/services/data/v24.0/sobjects/Vendor__c/a06d000000EHN4nAAH\"},\"Id\":\"a06d000000EHN4nAAH\",\"Name\":\"The Ice Cream Factory\",\"VendorId__c\":\"24\"},\"envelope__r\":{\"attributes\":{\"type\":\"Envelope__c\",\"url\":\"/services/data/v24.0/sobjects/Envelope__c/a07d0000006cBy1AAE\"},\"Id\":\"a07d0000006cBy1AAE\",\"Name\":\"Lunches\",\"EnvelopeId__c\":\"1\"}}]}";
			var jsonResponse : Object = JSON.parse(rawHttpResponse);
			var expectedSoqlQuery : String = "SELECT t.recordedTransactionId__c, t.Id, t.Name, t.amount__c, t.date__c, t.envelope__c, t.vendor__c, t.vendor__r.Id, t.vendor__r.Name,t.vendor__r.VendorId__c, t.envelope__r.Id, t.envelope__r.Name, t.envelope__r.EnvelopeId__c FROM RecordedTransaction__c t";

			Expect.call(organization.accessToken).returnValue("accessToken");
			Expect.call(remoteService.setAccessToken(null)).constraints([Is.equal("accessToken")]);

			Expect.call(organization.url).returnValue("url");
			Expect.call(remoteService.setOrgInstanceUrl(null)).constraints([Is.equal("url")]);

			Expect.call(remoteService.addEventListener(null, null)).constraints([Is.equal(SoqlQueryResultEvent.RESULT), Is.typeOf(Function)]).doAction(function(type : String, listener : Function) : void
			{
				// note: unfortunately this code is needed to simulate the internal adding of an event listener to the service
				// since we are mocking the adding of an event, nothing will happen, so we have to call the listener manually
				// in the doAction of the Expect.call(remoteService.call(..  below
				onResultListener = listener;
			});

			Expect.call(remoteService.executeQuery(null)).constraints([Is.equal(expectedSoqlQuery)]).doAction(function(query : String) : void
			{
				var event : SoqlQueryResultEvent = new SoqlQueryResultEvent(jsonResponse.records);
				onResultListener(event);
			});

			Expect.call(remoteService.removeEventListener(null, null)).constraints([Is.equal(SoqlQueryResultEvent.RESULT), Is.typeOf(Function)]);

			mockRepository.replayAll();

			command = new ListRecordedTransactionsCommand(remoteService, logFactory);

			command.execute(function(result : Object) : void
			{
				var recordedTransactions : IList = IList(result);

				assertThat(recordedTransactions, arrayWithSize(3));
				assertThat(recordedTransactions, everyItem(isA(RecordedTransaction)));

			}, organization, context);

			mockRepository.verifyAll();
		}
	}
}
