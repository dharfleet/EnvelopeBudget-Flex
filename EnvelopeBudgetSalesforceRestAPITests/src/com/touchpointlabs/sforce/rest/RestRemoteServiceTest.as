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
package com.touchpointlabs.sforce.rest
{
	import asmock.framework.MockRepository;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import flash.events.Event;

	import mx.rpc.http.HTTPService;
	import mx.rpc.http.test.HTTPServiceStub;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.hamcrest.core.anything;


	public class RestRemoteServiceTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([LogFactory, Logger]);


		private var service : JsonRestRemoteService;
		private var apiVersion : String;
		private var logFactory : LogFactory;
		private var mockRepository : MockRepository;

		private var httpService : HTTPService;


		[Before]
		public function setUp() : void
		{
			logFactory = LoggingSupport.mockLogger();
			httpService = new HTTPServiceStub();
			HTTPServiceStub(httpService).delay = 100;
			apiVersion = "v25.0";
		}


		[Test]
		public function testRestRemoteService() : void
		{
			service = new JsonRestRemoteService(httpService, apiVersion, logFactory);

			assertEquals(HTTPService.RESULT_FORMAT_TEXT, httpService.resultFormat);
			assertEquals(httpService.contentType, "application/json");
		}


		[Test]
		public function testAddHeader() : void
		{
			service = new JsonRestRemoteService(httpService, apiVersion, logFactory);

			service.addHeader("key1", "value1");

			assertEquals(httpService.headers.key1, "value1");
		}


		[Test]
		public function testAddParameter() : void
		{
			service = new JsonRestRemoteService(httpService, apiVersion, logFactory);

			service.addParameter("key1", "value1");

			assertEquals(httpService.request.key1, "value1");
		}


		[Test(async)]
		public function testAppendToUrl() : void
		{
			HTTPServiceStub(httpService).result(null, {"Accept": "application/json"}, "GET", null);
			service = new JsonRestRemoteService(httpService, apiVersion, logFactory);
			service.addEventListener(JsonResultEvent.RESULT, Async.asyncHandler(this, function(event : Event, passThroughData : Object) : void
			{
				assertThat(anything("we are not interested in the result for this test"));
			}, 1000));

			service.appendToUrl("appendix");
			service.call();

			assertEquals("null/services/data/v25.0/appendix", httpService.url);
		}


		[Test]
		public function testSetAccessToken() : void
		{
			service = new JsonRestRemoteService(httpService, apiVersion, logFactory);

			service.setAccessToken("[accessToken]");

			assertEquals("OAuth [accessToken]", httpService.headers.authorization);
		}


		[Test(async)]
		public function testSetOrgInstanceUrl() : void
		{
			HTTPServiceStub(httpService).result(null, {"Accept": "application/json"}, "GET", null);
			service = new JsonRestRemoteService(httpService, apiVersion, logFactory);
			service.addEventListener(JsonResultEvent.RESULT, Async.asyncHandler(this, function(event : Event, passThroughData : Object) : void
			{
				assertThat(anything("we are not interested in the result for this test"));
			}, 1000));

			service.setOrgInstanceUrl("https:na14.salesforce.com");
			service.call();

			assertEquals("https:na14.salesforce.com/services/data/v25.0/", httpService.url);
		}


		[Test]
		public function testSetJsonParameter() : void
		{
			var jsonRecord : Object = {Id: "kdjsf389", Name: "Lunch"};
			service = new JsonRestRemoteService(httpService, apiVersion, logFactory);

			service.setJsonParameter(jsonRecord);

			assertEquals(jsonRecord, httpService.request);
		}


		[Test]
		public function testAddJsonResultListener() : void
		{
			service = new JsonRestRemoteService(httpService, apiVersion, logFactory);
			var listener : Function = function() : void
			{
			};
			assertFalse(service.hasEventListener(JsonResultEvent.RESULT));

			service.addJsonResultListener(listener);

			assertTrue(service.hasEventListener(JsonResultEvent.RESULT));
		}


		[Test]
		public function testRemoveJsonResultListener() : void
		{
			service = new JsonRestRemoteService(httpService, apiVersion, logFactory);
			var listener : Function = function() : void
			{
			};
			service.addJsonResultListener(listener);
			assertTrue(service.hasEventListener(JsonResultEvent.RESULT));

			service.removeJsonResultListener(listener);

			assertFalse(service.hasEventListener(JsonResultEvent.RESULT));
		}


		[Test(async)]
		public function testCall() : void
		{
			HTTPServiceStub(httpService).result(null, {"Accept": "application/json"}, "GET", "{\"Id\":\"AAAb345\",\"Name\":\"Dinner\"}");
			service = new JsonRestRemoteService(httpService, apiVersion, logFactory);
			service.addEventListener(JsonResultEvent.RESULT, Async.asyncHandler(this, function(event : JsonResultEvent, passThroughData : Object) : void
			{
				assertEquals("AAAb345", event.data.Id);
				assertEquals("Dinner", event.data.Name);
			}, 1000));

			service.setOrgInstanceUrl("https:na14.salesforce.com");
			service.call();
		}
	}
}
