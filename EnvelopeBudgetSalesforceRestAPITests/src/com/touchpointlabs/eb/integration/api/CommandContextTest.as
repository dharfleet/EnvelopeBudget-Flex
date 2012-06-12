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
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;


	public class CommandContextTest
	{
		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([Logger, LogFactory]);

		private var mockRepository : MockRepository;
		private var logFactory : LogFactory;

		private var context : CommandContext;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			logFactory = LoggingSupport.mockLoggerForClass(CommandContext, mockRepository, LoggingSupport.LOG_LEVEL_DEBUG, true);
			context = new CommandContext(logFactory);

		}


		[After]
		public function tearDown() : void
		{
			context = null;
		}


		[Test]
		public function testAddWhenDoesNotExist() : void
		{
			var value : Object = new Object();
			var key : String = "key";

			context.add(key, value);

			var actual : Object = context.get(key);
			var expected : Object = value;

			assertEquals(expected, actual);
		}


		[Test]
		public function testAddWhenExists() : void
		{
			var oldValue : Object = new Object();
			var newValue : Object = new Object();
			var key : String = "key";

			context.add(key, oldValue);
			context.add(key, newValue);

			var actual : Object = context.get(key);
			var expected : Object = newValue;

			assertEquals(expected, actual);
		}


		[Test]
		public function testExistsYes() : void
		{
			var value : Object = new Object();
			var key : String = "key";

			context.add(key, value);

			assertTrue(context.exists(key));
		}


		[Test]
		public function testExistsNo() : void
		{
			assertFalse(context.exists("key"));
		}


		[Test]
		public function testGetWhenExists() : void
		{
			var value : Object = new Object();
			var key : String = "key";
			context.add(key, value);
			var expected : Object = value;

			var actual : Object = context.get(key);

			assertEquals(expected, actual);
		}


		[Test]
		public function testGetWhenDoesNotExist() : void
		{
			var expected : Object = null;
			var key : String = "key";

			var actual : Object = context.get(key);

			assertEquals(expected, actual);
		}


		[Test]
		public function testRemoveWhenExists() : void
		{
			var value : Object = new Object();
			var key : String = "key";
			context.add(key, value);

			var result : Boolean = context.remove(key);

			assertTrue(result);
		}


		[Test]
		public function testRemoveWhenDoesNotExist() : void
		{
			var key : String = "key";

			var result : Boolean = context.remove(key);

			assertFalse(result);
		}
	}
}
