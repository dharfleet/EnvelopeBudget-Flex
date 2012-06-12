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
	import com.touchpointlabs.sforce.rest.remote.CreateRecordRemoteService;
	import com.touchpointlabs.sforce.rest.remote.RecordEvent;


	public class CreateVendorCommand
	{
		public static const KEY_VENDOR_NAME_TO_CREATE : String = "VENDOR_NAME_TO_CREATE";

		public function CreateVendorCommand(remoteService : CreateRecordRemoteService, logFactory : LogFactory)
		{
			this.remoteService = remoteService;
			this.log = logFactory.getLogger(CreateVendorCommand);
			this.log.debug("constructor");
		}


		public function execute(callback : Function, organization : SalesforceOrg, context : CommandContext) : void
		{
			this._callback = callback;

			if (!context.exists(KEY_VENDOR_NAME_TO_CREATE))
			{
				log.prettyPrintObjectIfDebugEnabled(context, "context not found to contain everything the command needs");
				_callback(new ContextKeyNotFoundFaultEvent(KEY_VENDOR_NAME_TO_CREATE));
			}
			else
			{
				this.context = context;

				remoteService.setAccessToken(organization.accessToken);
				remoteService.setOrgInstanceUrl(organization.url);

				var vendorName : String = String(context.get(KEY_VENDOR_NAME_TO_CREATE));
				var jsonVendor : Object = JSON.stringify({name: vendorName});

				remoteService.addEventListener(RecordEvent.RECORD, onResult);

				log.debug("calling the remote service");
				remoteService.call(jsonVendor, "Vendor__c");
			}
		}


		protected function onResult(recordEvent : RecordEvent) : void
		{
			remoteService.removeEventListener(RecordEvent.RECORD, onResult);
			context.remove(KEY_VENDOR_NAME_TO_CREATE);

			var vendorId : String = String(recordEvent.record);
			log.debug("onResult, the vendorId is {0}", vendorId);

			context.add(GetVendorCommand.KEY_VENDOR_ID, vendorId);
			_callback(vendorId);
		}


		private var remoteService : CreateRecordRemoteService;
		private var _callback : Function;
		private var context : CommandContext;

		private var log : Logger;
	}
}
