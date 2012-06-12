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
package com.touchpointlabs.eb.dao
{
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.SetupResult;
	import asmock.framework.constraints.Is;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.integration.api.CommandContext;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommand;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommandFactory;
	import com.touchpointlabs.eb.integration.api.authn.UserCredentials;
	import com.touchpointlabs.eb.integration.api.envelope.ListEnvelopesCommand;
	import com.touchpointlabs.eb.integration.api.envelope.ListEnvelopesCommandFactory;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertNull;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class SfEnvelopeDaoTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([SalesforceOrg, UserCredentials, LoginCommand, LoginCommandFactory, ListEnvelopesCommand, ListEnvelopesCommandFactory, Envelope, Logger, LogFactory]);


		private var mockRepository : MockRepository;

		private var organization : SalesforceOrg;
		private var credentials : UserCredentials;
		private var loginCommandFactory : LoginCommandFactory;
		private var loginCommand : LoginCommand;
		private var listEnvelopesCommandFactory : ListEnvelopesCommandFactory;
		private var listEnvelopesCommand : ListEnvelopesCommand;
		private var logFactory : LogFactory;

		private var dao : SfEnvelopeDao;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			logFactory = LoggingSupport.mockLogger();

			organization = SalesforceOrg(mockRepository.createStrict(SalesforceOrg, [null, null, null]));
			credentials = UserCredentials(mockRepository.createStrict(UserCredentials, [null, null, null]));

			loginCommandFactory = LoginCommandFactory(mockRepository.createStrict(LoginCommandFactory));
			loginCommand = LoginCommand(mockRepository.createStrict(LoginCommand));
			SetupResult.forCall(loginCommandFactory.newLoginCommand()).returnValue(loginCommand);

			listEnvelopesCommandFactory = ListEnvelopesCommandFactory(mockRepository.createStrict(ListEnvelopesCommandFactory));
			listEnvelopesCommand = ListEnvelopesCommand(mockRepository.createStrict(ListEnvelopesCommand, [null, logFactory]));
			SetupResult.forCall(listEnvelopesCommandFactory.newListEnvelopesCommand()).returnValue(listEnvelopesCommand);

			dao = new SfEnvelopeDao(organization, credentials, loginCommandFactory, listEnvelopesCommandFactory, logFactory);
		}


		[After]
		public function tearDown() : void
		{
			mockRepository = null;
			loginCommandFactory = null;
			listEnvelopesCommandFactory = null;
			organization = null;
			credentials = null;
			dao = null;
		}


		[Test]
		public function testConstructor() : void
		{
			mockRepository.replayAll();

			dao = new SfEnvelopeDao(organization, credentials, loginCommandFactory, listEnvelopesCommandFactory, logFactory);

			mockRepository.verifyAll();
		}


		[Test]
		public function testFindAll() : void
		{
			var envelope1 : Envelope = Envelope(mockRepository.createStrict(Envelope));
			SetupResult.forCall(envelope1.id).returnValue(1);
			SetupResult.forCall(envelope1.name).returnValue("1");

			var envelope2 : Envelope = Envelope(mockRepository.createStrict(Envelope));
			SetupResult.forCall(envelope2.id).returnValue(2);
			SetupResult.forCall(envelope2.name).returnValue("2");

			var envelope3 : Envelope = Envelope(mockRepository.createStrict(Envelope));
			SetupResult.forCall(envelope3.id).returnValue(3);
			SetupResult.forCall(envelope3.name).returnValue("3");

			var all : IList = new ArrayCollection([envelope1, envelope2, envelope3]);

			Expect.call(loginCommand.execute(null, null)).constraints([Is.typeOf(Function), Is.equal(credentials)]).doAction(function(callback : Function, credentials : UserCredentials) : void
			{
				callback(organization);
			});

			Expect.call(listEnvelopesCommand.execute(null, null, null)).constraints([Is.typeOf(Function), Is.typeOf(SalesforceOrg), Is.typeOf(CommandContext)]).doAction(function(callback : Function, org : SalesforceOrg, context : CommandContext) : void
			{
				callback(all);
			});

			mockRepository.replayAll();

			dao = new SfEnvelopeDao(organization, credentials, loginCommandFactory, listEnvelopesCommandFactory, logFactory);

			var listToPopulate : IList = new ArrayCollection();

			dao.findAll(listToPopulate);

			mockRepository.verifyAll();

			assertThat(listToPopulate, arrayWithSize(3));
			assertThat(listToPopulate, everyItem(isA(Envelope)));
			assertThat(listToPopulate, hasItems(equalTo(envelope1), equalTo(envelope2), equalTo(envelope3)));
		}


		[Test]
		public function testFindById() : void
		{
			mockRepository.replayAll();

			dao = new SfEnvelopeDao(organization, credentials, loginCommandFactory, listEnvelopesCommandFactory, logFactory);
			var nullDueToNotImplemented : Envelope = null;
			assertNull("this method is not implemented for the Force.com solution", nullDueToNotImplemented);
			mockRepository.verifyAll();

		}
	}
}
