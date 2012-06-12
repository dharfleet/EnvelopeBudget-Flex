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
package com.touchpointlabs.eb.domain.service
{
	import com.touchpointlabs.eb.domain.entity.Vendor;

	import mx.collections.IList;


	/**
	 * domain service primarily relating to Vendors
	 * <p>
	 */
	public interface VendorService
	{

		/**
		 * creates a vendor
		 * @param vendorName name of the vendor, for example 'Walmart'
		 * @return vendor which has just been created, with unique id populated
		 * <p>
		 * note that if the name is the same as an existing vendor, a
		 * new vendor will be created with a different id
		 */
		function createVendor(vendorName : String, listToAddResultTo : IList=null) : void

		/**
		 * lists all vendors created by the user
		 * @param listToPopulate the list to fill with the results (async)
		 */
		function listVendors(listToPopulate : IList) : void
	}
}
