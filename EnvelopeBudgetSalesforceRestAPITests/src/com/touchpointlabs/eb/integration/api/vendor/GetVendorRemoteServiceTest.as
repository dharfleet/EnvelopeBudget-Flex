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

	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.JsonResultEvent;
	import com.touchpointlabs.sforce.rest.remote.GetRecordRemoteService;


	public class GetVendorRemoteServiceTest
	{
		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([GetRecordRemoteService, Logger, LogFactory]);


		private var mockRepository : MockRepository;
		private var getRecordRemoteService : GetRecordRemoteService;
		private var logFactory : LogFactory;

		private var service : GetVendorRemoteService;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			logFactory = LoggingSupport.mockLogger();
			getRecordRemoteService = GetRecordRemoteService(mockRepository.createStrict(GetRecordRemoteService, [null, logFactory]));
		}


		[After]
		public function tearDown() : void
		{
			mockRepository = null;
			getRecordRemoteService = null;
		}


		[Test]
		public function testConstructor() : void
		{
			mockRepository.replayAll();

			service = new GetVendorRemoteService(getRecordRemoteService, logFactory);

			mockRepository.verifyAll();
		}


		[Test]
		public function testSetAccessToken() : void
		{
			Expect.call(getRecordRemoteService.setAccessToken(null)).constraints([Is.equal("accessToken")]);
			mockRepository.replayAll();
			service = new GetVendorRemoteService(getRecordRemoteService, logFactory);

			service.setAccessToken("accessToken");

			mockRepository.verifyAll();
		}


		[Test]
		public function testSetOrgInstanceUrl() : void
		{
			Expect.call(getRecordRemoteService.setOrgInstanceUrl(null)).constraints([Is.equal("https://serverInstance.salesforce.com")]);
			mockRepository.replayAll();
			service = new GetVendorRemoteService(getRecordRemoteService, logFactory);

			service.setOrgInstanceUrl("https://serverInstance.salesforce.com");

			mockRepository.verifyAll();
		}


		[Test]
		public function testCallGetVendor() : void
		{
			var recordIdFixture : String = "AAAb.cy8e8fue.ldg";
			Expect.call(getRecordRemoteService.addEventListener(null, null)).constraints([Is.equal(JsonResultEvent.RESULT), Is.typeOf(Function)]);
			Expect.call(getRecordRemoteService.call(null, null)).constraints([Is.equal(recordIdFixture), Is.equal("Vendor__c")]);
			mockRepository.replayAll();
			service = new GetVendorRemoteService(getRecordRemoteService, logFactory);

			service.callGetVendor(recordIdFixture);

			mockRepository.verifyAll();
		}
	}
}
