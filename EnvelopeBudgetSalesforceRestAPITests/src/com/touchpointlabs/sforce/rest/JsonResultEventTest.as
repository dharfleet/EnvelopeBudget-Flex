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
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;

	public class JsonResultEventTest
	{

		private var event : JsonResultEvent;
		private var data : Object;


		[Before]
		public function setUp() : void
		{
			data = {Id: "1", Name: "Glass of Water"}
			event = new JsonResultEvent(data);
		}


		[After]
		public function tearDown() : void
		{
			data = null;
			event = null;
		}


		[Test]
		public function testJsonResultEvent() : void
		{
			assertEquals(JsonResultEvent.RESULT, event.type);
			assertFalse(event.bubbles);
			assertFalse(event.cancelable);
		}


		[Test]
		public function testData() : void
		{
			assertEquals(data, event.data);
		}


		[Test]
		public function testClone() : void
		{
			var cloned : JsonResultEvent = JsonResultEvent(event.clone());

			assertThat(event, not(equalTo(cloned)));
			assertThat(cloned.data, allOf(equalTo(event.data), equalTo(data)))

			assertEquals(JsonResultEvent.RESULT, cloned.type);
			assertFalse(cloned.bubbles);
			assertFalse(cloned.cancelable);

		}
	}
}
