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
package com.touchpointlabs.collections
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;

	public class ListUtilsTest
	{

		private var list : IList;

		private var a : Object;
		private var b : Object;
		private var c : Object;
		private var c2 : Object;
		private var z : Object;

		[Before]
		public function setUp() : void
		{
			a = {Name: "a", Id: "a07d0000006cBy1"};
			b = {Name: "b", Id: "a07d0000006cBy2"};
			c = {Name: "c", Id: "a07d0000006cBy3"};
			list = new ArrayCollection([a, b, c]);
		}


		[After]
		public function tearDown() : void
		{
			list = null;
		}


		[Test]
		public function testFindElementIndex() : void
		{
			assertEquals("a", 0, ListUtils.findElementIndex(list, "Id", "a07d0000006cBy1"));
			assertEquals("b", 1, ListUtils.findElementIndex(list, "Id", "a07d0000006cBy2"));
			assertEquals("c", 2, ListUtils.findElementIndex(list, "Id", "a07d0000006cBy3"));
			assertEquals("should not be there", ListUtils.NOT_FOUND_INDEX, ListUtils.findElementIndex(list, "Id", "a07d0000006cBy99"));
		}


		[Test]
		public function testMerge() : void
		{

			c2 = {Name: "c2", Id: "a07d0000006cBy3"};
			z = {Name: "z", Id: "a07d0000006cBy1944"};
			var source : IList = new ArrayCollection([c2, z]);

			var destination : IList = list;

			ListUtils.merge(source, destination, "Id");

			assertThat("the destination should have had one element added so be 4 in length", destination, arrayWithSize(4));
			assertThat("the source should not have been affected", source, arrayWithSize(2));
			assertThat("a, b, c2 and z are the four expected elements", destination, hasItems(equalTo(a), equalTo(b), equalTo(c2), equalTo(z)));
			assertThat("c should have been removed", destination, not(hasItem(equalTo(c))));

		}
	}
}
