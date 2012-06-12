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
	import com.touchpointlabs.eb.integration.api.ContextKeyNotFoundFaultEvent;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;
	import com.touchpointlabs.sforce.rest.remote.RecordEvent;

	import mx.rpc.Fault;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.object.instanceOf;


	public class GetEnvelopeCommandTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([GetEnvelopeRemoteService, CommandContext, SalesforceOrg, Envelope, Logger, LogFactory]);

		private var mockRepository : MockRepository;
		private var remoteService : GetEnvelopeRemoteService;
		private var organization : SalesforceOrg;
		private var context : CommandContext;
		private var logFactory : LogFactory;

		private var command : GetEnvelopeCommand;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			logFactory = LoggingSupport.mockLogger()
			remoteService = GetEnvelopeRemoteService(mockRepository.createStrict(GetEnvelopeRemoteService, [null, logFactory, null]));
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

			command = new GetEnvelopeCommand(remoteService, logFactory);

			mockRepository.verify(remoteService);
		}


		[Test]
		public function testExecute() : void
		{
			var onResultListener : Function;

			var envelopeIdToGet : String = "AAAhu89defew.dkije";
			var envelopeGot : Envelope = Envelope(mockRepository.createStrict(Envelope));

			Expect.call(context.exists(null)).constraints([Is.equal(GetEnvelopeCommand.KEY_ENVELOPE_ID)]).returnValue(true);
			Expect.call(context.get(null)).constraints([Is.equal(GetEnvelopeCommand.KEY_ENVELOPE_ID)]).returnValue(envelopeIdToGet);
			Expect.call(organization.accessToken).returnValue("accessToken");
			Expect.call(remoteService.setAccessToken(null)).constraints([Is.equal("accessToken")]);

			Expect.call(organization.url).returnValue("url");
			Expect.call(remoteService.setOrgInstanceUrl(null)).constraints([Is.equal("url")]);

			Expect.call(remoteService.addEventListener(null, null)).constraints([Is.equal(RecordEvent.RECORD), Is.typeOf(Function)]).doAction(function(type : String, listener : Function) : void
			{
				// note: unfortunately this code is needed to simulate the internal adding of an event listener to the service
				// since we are mocking the adding of an event, nothing will happen, so we have to call the listener manually
				// in the doAction of the Expect.call(remoteService.call(..  below
				onResultListener = listener;
			});

			Expect.call(remoteService.callGetEnvelope(null)).constraints([Is.equal(envelopeIdToGet)]).doAction(function(recordId : String) : void
			{
				var recordEvent : RecordEvent = new RecordEvent(envelopeGot);

				onResultListener(recordEvent);
			});

			mockRepository.replayAll();

			command = new GetEnvelopeCommand(remoteService, logFactory);

			command.execute(function(result : Object) : void
			{
				assertEquals(envelopeGot, result);
			}, organization, context);

			mockRepository.verifyAll();
		}


		[Test]
		public function testExecuteWithBadContext() : void
		{
			Expect.call(context.exists(null)).constraints([Is.equal(GetEnvelopeCommand.KEY_ENVELOPE_ID)]).returnValue(false);

			mockRepository.replayAll();

			command = new GetEnvelopeCommand(remoteService, logFactory);

			command.execute(function(result : Object) : void
			{
				assertThat(result, instanceOf(ContextKeyNotFoundFaultEvent));

				var event : ContextKeyNotFoundFaultEvent = ContextKeyNotFoundFaultEvent(result);
				var fault : Fault = event.fault;

				assertEquals("9001", fault.faultCode);
				assertEquals("The CommandContext could not find the key with the name " + GetEnvelopeCommand.KEY_ENVELOPE_ID, fault.faultDetail);
				assertEquals(GetEnvelopeCommand.KEY_ENVELOPE_ID, fault.faultString);

			}, organization, context);


			mockRepository.verifyAll();
		}
	}
}
