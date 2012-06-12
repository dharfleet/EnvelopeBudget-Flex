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
package com.touchpointlabs.eb.integration.api.envelope
{
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.constraints.Is;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.Envelope;
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


	public class ListEnvelopesCommandTest
	{
		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([SoqlQueryRemoteService, CommandContext, SalesforceOrg, Logger, LogFactory]);


		private var mockRepository : MockRepository;
		private var remoteService : SoqlQueryRemoteService;
		private var organization : SalesforceOrg;
		private var context : CommandContext;
		private var logFactory : LogFactory;

		private var command : ListEnvelopesCommand;


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
			organization = null;
			context = null;
		}


		[Test]
		public function testConstructor() : void
		{
			mockRepository.replay(remoteService);

			command = new ListEnvelopesCommand(remoteService, logFactory);

			mockRepository.verify(remoteService);
		}


		[Test]
		public function testExecute() : void
		{
			var onResultListener : Function;

			var envelopeId1 : String = "AAB12fj001";
			var envelopeName1 : String = "Meals";
			var envelopeId__c1 : int = 1;

			var envelopeId2 : String = "AAB12fj002";
			var envelopeName2 : String = "Internet & Phone";
			var envelopeId__c2 : int = 2;

			var envelopeId3 : String = "AAB12fj003";
			var envelopeName3 : String = "Gifts";
			var envelopeId__c3 : int = 3;

			var jsonEnvelope1 : Object = {Id: envelopeId1, Name: envelopeName1, EnvelopeId__c: envelopeId__c1};
			var jsonEnvelope2 : Object = {Id: envelopeId2, Name: envelopeName2, EnvelopeId__c: envelopeId__c2};
			var jsonEnvelope3 : Object = {Id: envelopeId3, Name: envelopeName3, EnvelopeId__c: envelopeId__c3};

			var jsonResult : Array = [jsonEnvelope1, jsonEnvelope2, jsonEnvelope3];

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

			Expect.call(remoteService.executeQuery(null)).constraints([Is.equal("SELECT EnvelopeId__c, Id, Name FROM Envelope__c")]).doAction(function(query : String) : void
			{
				var event : SoqlQueryResultEvent = new SoqlQueryResultEvent(jsonResult);
				onResultListener(event);
			});

			Expect.call(remoteService.removeEventListener(null, null)).constraints([Is.equal(SoqlQueryResultEvent.RESULT), Is.typeOf(Function)]);

			mockRepository.replayAll();

			command = new ListEnvelopesCommand(remoteService, logFactory);

			command.execute(function(result : Object) : void
			{
				var envelopes : IList = IList(result);

				assertThat(envelopes, arrayWithSize(3));
				assertThat(envelopes, everyItem(isA(Envelope)));

			}, organization, context);

			mockRepository.verifyAll();
		}
	}
}
