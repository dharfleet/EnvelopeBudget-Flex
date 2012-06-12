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
package com.touchpointlabs.eb.integration.api
{
	import asmock.framework.MockRepository;
	import asmock.framework.SetupResult;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.integration.api.authn.LoginCommand;
	import com.touchpointlabs.eb.integration.api.envelope.CreateEnvelopeCommand;
	import com.touchpointlabs.eb.integration.api.envelope.GetEnvelopeCommand;
	import com.touchpointlabs.eb.integration.api.envelope.ListEnvelopesCommand;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.CreateRecordedTransactionCommand;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.GetRecordedTransactionCommand;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.ListRecordedTransactionsCommand;
	import com.touchpointlabs.eb.integration.api.vendor.CreateVendorCommand;
	import com.touchpointlabs.eb.integration.api.vendor.GetVendorCommand;
	import com.touchpointlabs.eb.integration.api.vendor.ListVendorsCommand;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;

	import org.flexunit.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;


	public class CommandFactoryTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([SalesforceOrg, LogFactory, Logger]);

		private var mockRepository : MockRepository;
		private var organization : SalesforceOrg;
		private var logFactory : LogFactory;
		private var factory : CommandFactory;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			organization = SalesforceOrg(mockRepository.createStrict(SalesforceOrg, [null, null, null]));
			SetupResult.forCall(organization.apiVersion).returnValue("v24.0");
			logFactory = LoggingSupport.mockLogger();
			mockRepository.replayAll()
			factory = new CommandFactory(organization, logFactory);
		}


		[After]
		public function tearDown() : void
		{
			factory = null;
			organization = null;
			mockRepository = null;
		}


		[Test]
		public function testNewCreateEnvelopeCommand() : void
		{
			var command1 : CreateEnvelopeCommand = factory.newCreateEnvelopeCommand();
			var command2 : CreateEnvelopeCommand = factory.newCreateEnvelopeCommand();

			assertThat(command1, notNullValue());
			assertThat(command2, notNullValue());
			assertThat(command1, not(equalTo(command2)));
		}


		[Test]
		public function testNewCreateRecordedTransactionCommand() : void
		{
			var command1 : CreateRecordedTransactionCommand = factory.newCreateRecordedTransactionCommand()
			var command2 : CreateRecordedTransactionCommand = factory.newCreateRecordedTransactionCommand()

			assertThat(command1, notNullValue());
			assertThat(command2, notNullValue());
			assertThat(command1, not(equalTo(command2)));
		}


		[Test]
		public function testNewCreateVendorCommand() : void
		{
			var command1 : CreateVendorCommand = factory.newCreateVendorCommand();
			var command2 : CreateVendorCommand = factory.newCreateVendorCommand();

			assertThat(command1, notNullValue());
			assertThat(command2, notNullValue());
			assertThat(command1, not(equalTo(command2)));
		}


		[Test]
		public function testNewGetEnvelopeCommand() : void
		{
			var command1 : GetEnvelopeCommand = factory.newGetEnvelopeCommand();
			var command2 : GetEnvelopeCommand = factory.newGetEnvelopeCommand();

			assertThat(command1, notNullValue());
			assertThat(command2, notNullValue());
			assertThat(command1, not(equalTo(command2)));
		}


		[Test]
		public function testNewGetRecordedTransactionCommand() : void
		{
			var command1 : GetRecordedTransactionCommand = factory.newGetRecordedTransactionCommand();
			var command2 : GetRecordedTransactionCommand = factory.newGetRecordedTransactionCommand();

			assertThat(command1, notNullValue());
			assertThat(command2, notNullValue());
			assertThat(command1, not(equalTo(command2)));
		}


		[Test]
		public function testNewGetVendorCommand() : void
		{
			var command1 : GetVendorCommand = factory.newGetVendorCommand();
			var command2 : GetVendorCommand = factory.newGetVendorCommand();

			assertThat(command1, notNullValue());
			assertThat(command2, notNullValue());
			assertThat(command1, not(equalTo(command2)));
		}


		[Test]
		public function testNewListEnvelopesCommand() : void
		{
			var command1 : ListEnvelopesCommand = factory.newListEnvelopesCommand();
			var command2 : ListEnvelopesCommand = factory.newListEnvelopesCommand();

			assertThat(command1, notNullValue());
			assertThat(command2, notNullValue());
			assertThat(command1, not(equalTo(command2)));
		}


		[Test]
		public function testNewListRecordedTransactionsCommand() : void
		{
			var command1 : ListRecordedTransactionsCommand = factory.newListRecordedTransactionsCommand();
			var command2 : ListRecordedTransactionsCommand = factory.newListRecordedTransactionsCommand();

			assertThat(command1, notNullValue());
			assertThat(command2, notNullValue());
			assertThat(command1, not(equalTo(command2)));
		}


		[Test]
		public function testNewListVendorsCommand() : void
		{
			var command1 : ListVendorsCommand = factory.newListVendorsCommand();
			var command2 : ListVendorsCommand = factory.newListVendorsCommand();

			assertThat(command1, notNullValue());
			assertThat(command2, notNullValue());
			assertThat(command1, not(equalTo(command2)));
		}


		[Test]
		public function testNewLoginCommand() : void
		{
			var command1 : LoginCommand = factory.newLoginCommand();
			var command2 : LoginCommand = factory.newLoginCommand();

			assertThat(command1, notNullValue());
			assertThat(command2, notNullValue());
			assertThat(command1, not(equalTo(command2)));
		}
	}
}
