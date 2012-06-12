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
	import com.touchpointlabs.eb.integration.api.authn.JsonLoginCommand;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommand;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommandFactory;
	import com.touchpointlabs.eb.integration.api.envelope.CreateEnvelopeCommand;
	import com.touchpointlabs.eb.integration.api.envelope.CreateEnvelopeCommandFactory;
	import com.touchpointlabs.eb.integration.api.envelope.GetEnvelopeCommand;
	import com.touchpointlabs.eb.integration.api.envelope.GetEnvelopeCommandFactory;
	import com.touchpointlabs.eb.integration.api.envelope.GetEnvelopeRemoteService;
	import com.touchpointlabs.eb.integration.api.envelope.ListEnvelopesCommand;
	import com.touchpointlabs.eb.integration.api.envelope.ListEnvelopesCommandFactory;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.CreateRecordedTransactionCommand;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.CreateRecordedTransactionCommandFactory;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.GetRecordedTransactionCommand;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.GetRecordedTransactionCommandFactory;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.ListRecordedTransactionsCommand;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.ListRecordedTransactionsCommandFactory;
	import com.touchpointlabs.eb.integration.api.vendor.CreateVendorCommand;
	import com.touchpointlabs.eb.integration.api.vendor.CreateVendorCommandFactory;
	import com.touchpointlabs.eb.integration.api.vendor.GetVendorCommand;
	import com.touchpointlabs.eb.integration.api.vendor.GetVendorCommandFactory;
	import com.touchpointlabs.eb.integration.api.vendor.GetVendorRemoteService;
	import com.touchpointlabs.eb.integration.api.vendor.ListVendorsCommand;
	import com.touchpointlabs.eb.integration.api.vendor.ListVendorsCommandFactory;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.JsonRestRemoteService;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;
	import com.touchpointlabs.sforce.rest.remote.CreateRecordRemoteService;
	import com.touchpointlabs.sforce.rest.remote.GetRecordRemoteService;
	import com.touchpointlabs.sforce.rest.remote.SoqlQueryRemoteService;

	import mx.rpc.http.HTTPService;

	public class CommandFactory implements LoginCommandFactory, CreateEnvelopeCommandFactory, GetEnvelopeCommandFactory, ListEnvelopesCommandFactory, CreateRecordedTransactionCommandFactory, GetRecordedTransactionCommandFactory, ListRecordedTransactionsCommandFactory, CreateVendorCommandFactory, GetVendorCommandFactory, ListVendorsCommandFactory
	{

		public function CommandFactory(organization : SalesforceOrg, logFactory : LogFactory)
		{
			this.organization = organization;
			this.logFactory = logFactory;
			this.log = logFactory.getLogger(CommandFactory);
			this.log.debug("constructor");
		}


		public function newLoginCommand() : LoginCommand
		{
			log.debug("new JsonLoginCommand");
			return new JsonLoginCommand(organization, new HTTPService(), logFactory);
		}


		public function newCreateEnvelopeCommand() : CreateEnvelopeCommand
		{
			log.debug("new CreateEnvelopeCommand");
			return new CreateEnvelopeCommand(createRecordRemoteService(), logFactory);
		}


		public function newGetEnvelopeCommand() : GetEnvelopeCommand
		{
			log.debug("new GetEnvelopeCommand");
			return new GetEnvelopeCommand(new GetEnvelopeRemoteService(getRecordRemoteService(), logFactory), logFactory);
		}


		public function newListEnvelopesCommand() : ListEnvelopesCommand
		{
			log.debug("new CreateRecordedTransactionCommand");
			return new ListEnvelopesCommand(soqlQueryRemoteService(), logFactory);
		}


		public function newCreateRecordedTransactionCommand() : CreateRecordedTransactionCommand
		{
			log.debug("new CreateRecordedTransactionCommand");
			return new CreateRecordedTransactionCommand(createRecordRemoteService(), logFactory);
		}


		public function newGetRecordedTransactionCommand() : GetRecordedTransactionCommand
		{
			log.debug("new GetRecordedTransactionCommand");
			return new GetRecordedTransactionCommand(soqlQueryRemoteService(), logFactory);
		}


		public function newListRecordedTransactionsCommand() : ListRecordedTransactionsCommand
		{
			log.debug("new ListRecordedTransactionsCommand");
			return new ListRecordedTransactionsCommand(soqlQueryRemoteService(), logFactory);
		}


		public function newCreateVendorCommand() : CreateVendorCommand
		{
			log.debug("new CreateVendorCommand");
			return new CreateVendorCommand(createRecordRemoteService(), logFactory);
		}


		public function newGetVendorCommand() : GetVendorCommand
		{
			log.debug("new GetVendorCommand");
			return new GetVendorCommand(new GetVendorRemoteService(getRecordRemoteService(), logFactory), logFactory);
		}


		public function newListVendorsCommand() : ListVendorsCommand
		{
			log.debug("new ListVendorsCommand");
			return new ListVendorsCommand(soqlQueryRemoteService(), logFactory);
		}


		private function soqlQueryRemoteService() : SoqlQueryRemoteService
		{
			log.debug("new SoqlQueryRemoteService");
			return new SoqlQueryRemoteService(new JsonRestRemoteService(httpGetService(), organization.apiVersion, logFactory), logFactory)
		}


		private function createRecordRemoteService() : CreateRecordRemoteService
		{
			log.debug("new CreateRecordRemoteService");
			return new CreateRecordRemoteService(new JsonRestRemoteService(httpPostService(), organization.apiVersion, logFactory), logFactory);
		}


		private function getRecordRemoteService() : GetRecordRemoteService
		{
			log.debug("new GetRecordRemoteService");
			return new GetRecordRemoteService(new JsonRestRemoteService(httpGetService(), organization.apiVersion, logFactory), logFactory);
		}


		private function httpPostService() : HTTPService
		{
			log.debug("new HTTPService (POST)");
			var httpService : HTTPService = new HTTPService();
			httpService.method = "POST";
			return httpService;
		}


		private function httpGetService() : HTTPService
		{
			log.debug("new HTTPService (GET)");
			return new HTTPService();
		}


		private var organization : SalesforceOrg;
		private var logFactory : LogFactory;

		private var log : Logger;
	}
}
