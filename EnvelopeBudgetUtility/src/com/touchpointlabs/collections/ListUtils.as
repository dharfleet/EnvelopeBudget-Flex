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
	import mx.collections.IList;

	public class ListUtils
	{

		public static const NOT_FOUND_INDEX : int = -1;


		/**
		 * merges the elements in the source list into the destination list
		 * @param source the list to add to the destination
		 * @param destination the list which will be updated
		 * @param the field name to match
		 * @param fieldNameToMatch the field name to match by, for example could be 'id', 'name', etc
		 * <p>
		 * Rules: For each element in the source
		 * 1. If the destination contains an element with the matching field, then the element is overwritten by the element from the source
		 * 2. If the destination does not contain an element with the matching field, then the element is added
		 */
		public static function merge(source : IList, destination : IList, fieldNameToMatch : String) : void
		{

			for (var index : uint = 0; index < source.length; index++)
			{
				var sourceElement : Object = source.getItemAt(index);
				var destinationIndex : int = findElementIndex(destination, fieldNameToMatch, sourceElement[fieldNameToMatch]);
				if (destinationIndex == NOT_FOUND_INDEX)
				{
					destination.addItem(sourceElement);
				}
				else
				{
					destination.setItemAt(sourceElement, destinationIndex);
				}
			}
		}


		/**
		 * searches for an object in the list which has the matching field (as opposed to just object equality)
		 * <p>
		 * always and only returns the first match
		 *
		 * @param listToSearch the list to search through
		 * @param fieldNameToMatch the name of the field, for example 'year'
		 * @param filedValueToMatch the value which must match, for example '2012';
		 * @return an int representing the index in the IList where the match was made (-1 otherwise)
		 */
		public static function findElementIndex(listToSearch : IList, fieldNameToMatch : String, fieldValueToMatch : String) : int
		{
			var result : int = -1;
			for (var index : uint = 0; index < listToSearch.length; index++)
			{
				var element : Object = listToSearch.getItemAt(index);
				if (element[fieldNameToMatch] == fieldValueToMatch)
				{
					result = index;
					break;
				}
			}
			return result;
		}



	}
}
