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
	import com.touchpointlabs.eb.integration.api.CommandFactory;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommandFactory;
	import com.touchpointlabs.eb.integration.api.authn.UserCredentials;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.CreateRecordedTransactionCommandFactory;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.GetRecordedTransactionCommandFactory;
	import com.touchpointlabs.eb.integration.api.recordedtransactions.ListRecordedTransactionsCommandFactory;
	import com.touchpointlabs.eb.integration.api.vendor.CreateVendorCommandFactory;
	import com.touchpointlabs.eb.integration.api.vendor.GetVendorCommandFactory;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;

	public class SfRecordedTransactionDaoParsleyHack extends SfRecordedTransactionDao
	{

		// TODO (Future) - revisit amount of constructor args and Parsley restriction to 8
		/**
		 * This is a nasty hack to get parsley to work with constructor args greater than eight (Parsley is hard coded for 8). Currently the super class has nine constrcutor args. Since I know that all of the 6 different command factories
		 * are infact currently implemented by the same concrete instance, i just pass this in once and then pass it to the constructor for each command factory interface.
		 * nasty i know, i wanted to have a different interface for each method on the command factory.
		 */
		public function SfRecordedTransactionDaoParsleyHack(organization : SalesforceOrg, credentials : UserCredentials, commandFactory : CommandFactory, logFactory : LogFactory)
		{

			super(organization, credentials, commandFactory, commandFactory, commandFactory, commandFactory, commandFactory, commandFactory, logFactory);
		}
	}
}
