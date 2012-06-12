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
	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.integration.api.CommandContext;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommand;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommandFactory;
	import com.touchpointlabs.eb.integration.api.authn.UserCredentials;
	import com.touchpointlabs.eb.integration.api.envelope.ListEnvelopesCommand;
	import com.touchpointlabs.eb.integration.api.envelope.ListEnvelopesCommandFactory;
	import com.touchpointlabs.eb.integration.dao.EnvelopeDao;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;

	import mx.collections.IList;

	import org.spicefactory.lib.command.builder.Commands;

	public class SfEnvelopeDao implements EnvelopeDao
	{


		public function SfEnvelopeDao(organization : SalesforceOrg, credentials : UserCredentials, loginCommandFactory : LoginCommandFactory, listEnvelopesCommandFactory : ListEnvelopesCommandFactory, logFactory : LogFactory)
		{
			this.organization = organization;
			this.credentials = credentials;
			this.logFactory = logFactory;

			this.loginCommandFactory = loginCommandFactory;
			this.listEnvelopesCommandFactory = listEnvelopesCommandFactory;

			this.log = logFactory.getLogger(SfEnvelopeDao);
			this.log.debug("Constructor");
		}


		public function findAll(listToPopulate : IList) : void
		{
			this.findAllListToPopulate = listToPopulate;

			log.debug("findAll, listToPopulate provided with {0} items", listToPopulate.length);

			var loginCommand : LoginCommand = loginCommandFactory.newLoginCommand();
			var listEnvelopesCommand : ListEnvelopesCommand = listEnvelopesCommandFactory.newListEnvelopesCommand();

			Commands.asSequence().add(loginCommand).add(listEnvelopesCommand).lastResult(onFindAllResult).error(onFindAllError).data(credentials).data(new CommandContext(logFactory)).execute();
		}


		private function onFindAllResult(result : Object) : void
		{
			findAllListToPopulate.removeAll();

			for each (var envelope : Envelope in result)
			{
				findAllListToPopulate.addItem(envelope);
				log.debug("findAll, added Envelope with name {0}", envelope.name);
			}
		}


		private function onFindAllError(cause : Object) : void
		{
			log.error("findAll {0}", cause);
			log.prettyPrintObjectIfDebugEnabled(cause);
		}


		private var organization : SalesforceOrg;
		private var credentials : UserCredentials;
		private var loginCommandFactory : LoginCommandFactory;
		private var listEnvelopesCommandFactory : ListEnvelopesCommandFactory;
		private var logFactory : LogFactory;

		private var log : Logger;

		private var findAllListToPopulate : IList;
	}
}
