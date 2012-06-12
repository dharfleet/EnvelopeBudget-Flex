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
	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.integration.api.CommandContext;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommand;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommandFactory;
	import com.touchpointlabs.eb.integration.api.authn.UserCredentials;
	import com.touchpointlabs.eb.integration.api.vendor.CreateVendorCommand;
	import com.touchpointlabs.eb.integration.api.vendor.CreateVendorCommandFactory;
	import com.touchpointlabs.eb.integration.api.vendor.GetVendorCommand;
	import com.touchpointlabs.eb.integration.api.vendor.GetVendorCommandFactory;
	import com.touchpointlabs.eb.integration.api.vendor.ListVendorsCommand;
	import com.touchpointlabs.eb.integration.api.vendor.ListVendorsCommandFactory;
	import com.touchpointlabs.eb.integration.dao.VendorDao;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;

	import mx.collections.IList;

	import org.spicefactory.lib.command.builder.Commands;

	public class SfVendorDao implements VendorDao
	{

		public function SfVendorDao(organization : SalesforceOrg, credentials : UserCredentials, loginCommandFactory : LoginCommandFactory, createVendorCommandFactory : CreateVendorCommandFactory, listVendorsCommandFactory : ListVendorsCommandFactory, getVendorCommandFactory : GetVendorCommandFactory, logFactory : LogFactory)
		{
			this.organization = organization;
			this.credentials = credentials;
			this.loginCommandFactory = loginCommandFactory;
			this.createVendorCommandFactory = createVendorCommandFactory;
			this.getVendorCommandFactory = getVendorCommandFactory;
			this.listVendorsCommandFactory = listVendorsCommandFactory;
			this.logFactory = logFactory;
			this.log = logFactory.getLogger(SfVendorDao);
			this.log.debug("Constructor");

		}

		public function create(name : String, listToAddResultTo : IList) : void
		{
			var context : CommandContext = new CommandContext(this.logFactory);
			context.add(CreateVendorCommand.KEY_VENDOR_NAME_TO_CREATE, name);
			log.prettyPrintObjectIfDebugEnabled(context, "context");

			this.createListToAddResultTo = listToAddResultTo;
			log.debug("create, listToAddResultsTo already has {0} items", listToAddResultTo.length);

			var loginCommand : LoginCommand = loginCommandFactory.newLoginCommand();
			var createVendorCommand : CreateVendorCommand = createVendorCommandFactory.newCreateVendorCommand();
			var getVendorCommand : GetVendorCommand = getVendorCommandFactory.newGetVendorCommand();

			Commands.asSequence().add(loginCommand).add(createVendorCommand).add(getVendorCommand).data(credentials).data(context).lastResult(onCreateResult).error(onCreateError).execute();
		}

		public function findAll(listToPopulate : IList) : void
		{
			findAllListToPopulate = listToPopulate;
			log.debug("findAll, listToPopulate already has {0} items", listToPopulate);

			var loginCommand : LoginCommand = loginCommandFactory.newLoginCommand();
			var listVendorsCommand : ListVendorsCommand = listVendorsCommandFactory.newListVendorsCommand();

			Commands.asSequence().add(loginCommand).add(listVendorsCommand).data(credentials).data(new CommandContext(logFactory)).lastResult(onFindAllResult).error(onFindAllError).execute();
		}


		private function onFindAllResult(result : Object) : void
		{
			findAllListToPopulate.removeAll();

			for each (var vendor : Vendor in result)
			{
				log.debug("adding vendor with name {0} and id {1} to results", vendor.name, vendor.id);
				findAllListToPopulate.addItem(vendor);
			}
		}


		private function onFindAllError(cause : Object) : void
		{
			log.error("findAll, an error occured: {0}", cause);
			log.prettyPrintObjectIfDebugEnabled(cause);
		}


		private function onCreateResult(result : Object) : void
		{
			log.debug("adding {0} to the list", result);
			createListToAddResultTo.addItem(result);
		}


		private function onCreateError(cause : Object) : void
		{
			log.error("create, an error occured: {0}", cause);
			log.prettyPrintObjectIfDebugEnabled(cause);
		}


		private var organization : SalesforceOrg;
		private var credentials : UserCredentials;

		private var findAllListToPopulate : IList;
		private var createListToAddResultTo : IList;

		private var loginCommandFactory : LoginCommandFactory;
		private var createVendorCommandFactory : CreateVendorCommandFactory;
		private var getVendorCommandFactory : GetVendorCommandFactory;
		private var listVendorsCommandFactory : ListVendorsCommandFactory;


		private var logFactory : LogFactory;
		private var log : Logger;
	}
}
