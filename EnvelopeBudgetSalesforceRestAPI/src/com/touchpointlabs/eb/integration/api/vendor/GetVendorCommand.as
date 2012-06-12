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
package com.touchpointlabs.eb.integration.api.vendor
{
	import com.touchpointlabs.eb.integration.api.CommandContext;
	import com.touchpointlabs.eb.integration.api.ContextKeyNotFoundFaultEvent;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;
	import com.touchpointlabs.sforce.rest.remote.RecordEvent;


	public class GetVendorCommand
	{

		public static const KEY_VENDOR_ID : String = "VENDOR_ID";


		public function GetVendorCommand(api : GetVendorRemoteService, logFactory : LogFactory)
		{
			this.api = api;
			this.log = logFactory.getLogger(GetVendorCommand);
			this.log.debug("constructor");
		}


		public function execute(callback : Function, organization : SalesforceOrg, context : CommandContext) : void
		{
			this.callback = callback;

			if (!context.exists(KEY_VENDOR_ID))
			{
				log.prettyPrintObjectIfDebugEnabled(context, "context not found to contain everything the command needs");
				callback(new ContextKeyNotFoundFaultEvent(KEY_VENDOR_ID));
			}
			else
			{
				this.context = context;
				var vendorId : String = String(context.get(KEY_VENDOR_ID));

				api.setAccessToken(organization.accessToken);
				api.setOrgInstanceUrl(organization.url);

				api.addEventListener(RecordEvent.RECORD, onResult);

				log.debug("calling the remote service");
				api.callGetVendor(vendorId);
			}
		}


		private function onResult(event : RecordEvent) : void
		{
			log.debug("onResult {0}", event.record);
			callback(event.record);
		}

		private var api : GetVendorRemoteService;
		private var callback : Function;
		private var context : CommandContext;

		private var log : Logger;
	}
}
