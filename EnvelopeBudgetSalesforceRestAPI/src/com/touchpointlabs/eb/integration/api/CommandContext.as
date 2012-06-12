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
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;


	public class CommandContext
	{

		public function CommandContext(logFactory : LogFactory)
		{
			map = new Object();
			this.log = logFactory.getLogger(CommandContext);
		}


		public function add(key : String, value : Object) : void
		{
			map[key] = value;
			log.debug("add, key={0}, value={1}", key, value);
		}


		public function get(key : String) : Object
		{
			return map[key];
		}


		public function remove(key : String) : Boolean
		{
			var result : Boolean = exists(key);
			map[key] = null;
			log.debug("remove, key={0}, exists={1}", key, result);
			return result;
		}

		public function exists(key : String) : Boolean
		{
			return (map[key] != null && map[key] != "");
		}


		private var map : Object;

		private var log : Logger;
	}
}
