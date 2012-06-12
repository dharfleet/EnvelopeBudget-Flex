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
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.constraints.Is;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.Vendor;
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


	public class ListVendorsCommandTest
	{
		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([SoqlQueryRemoteService, CommandContext, SalesforceOrg, Logger, LogFactory]);


		private var mockRepository : MockRepository;
		private var remoteService : SoqlQueryRemoteService;
		private var organization : SalesforceOrg;
		private var context : CommandContext;
		private var logFactory : LogFactory;

		private var command : ListVendorsCommand;


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
			context = null;
		}


		[Test]
		public function testConstructor() : void
		{
			mockRepository.replay(remoteService);

			command = new ListVendorsCommand(remoteService, logFactory);

			mockRepository.verify(remoteService);
		}


		[Test]
		public function testExecute() : void
		{
			var onResultListener : Function;

			var vendorId1 : String = "AAB12fj001";
			var vendorName1 : String = "Starbucks";
			var vendorId__c1 : int = 1;

			var vendorId2 : String = "AAB12fj002";
			var vendorName2 : String = "Costa";
			var vendorId__c2 : int = 2;

			var vendorId3 : String = "AAB12fj003";
			var vendorName3 : String = "Cafe Nero";
			var vendorId__c3 : int = 3;

			var jsonVendor1 : Object = {Id: vendorId1, Name: vendorName1, VendorId__c: vendorId__c1};
			var jsonVendor2 : Object = {Id: vendorId2, Name: vendorName2, VendorId__c: vendorId__c2};
			var jsonVendor3 : Object = {Id: vendorId3, Name: vendorName3, VendorId__c: vendorId__c3};

			var jsonResult : Array = [jsonVendor1, jsonVendor2, jsonVendor3];

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

			Expect.call(remoteService.executeQuery(null)).constraints([Is.equal("SELECT VendorId__c, Id, Name FROM Vendor__c")]).doAction(function(query : String) : void
			{
				var event : SoqlQueryResultEvent = new SoqlQueryResultEvent(jsonResult);
				onResultListener(event);
			});

			Expect.call(remoteService.removeEventListener(null, null)).constraints([Is.equal(SoqlQueryResultEvent.RESULT), Is.typeOf(Function)]);

			mockRepository.replayAll();

			command = new ListVendorsCommand(remoteService, logFactory);

			command.execute(function(result : Object) : void
			{
				var vendors : IList = IList(result);

				assertThat(vendors, arrayWithSize(3));
				assertThat(vendors, everyItem(isA(Vendor)));

			}, organization, context);

			mockRepository.verifyAll();
		}
	}
}
