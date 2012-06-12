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
package com.touchpointlabs.sforce.rest.date
{


	import mx.utils.StringUtil;

	import spark.formatters.DateTimeFormatter;


	/**
	 * converts between ActionScript Date and ISO 8601 format date string as needed by Force.com REST API
	 * The format is yyyy-MM-dd'T'HH:mm:ss
	 * yyyy = year 4 digits
	 * MM = month 2 digits where January is 01 and December is 12
	 * HH = 24 hour clock hour 0 -23
	 * mm = minutes 00 -59
	 * ss = seconds 00 - 59
	 *
	 * Example: 2012-05-17T23:30:45
	 *
	 * @see http://en.wikipedia.org/wiki/ISO_8601
	 */
	public class SalesforceDateTranslator
	{

		/**
		 * Converts an ISO8601 formated date to an ActionScript date
		 * @param iso8601Date a string in ISO 8601 format
		 * @return an ActionScript date instance with values set as per input
		 * <p>
		 * see note at class level for format information
		 */
		public static function fromISO8601(iso8601Date : String) : Date
		{
			var matches : Array = iso8601Date.match(/(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)/);
			var date : Date = new Date(matches[1], matches[2] - 1, matches[3], matches[4], matches[5], matches[6]);
			return date;
		}


		/**
		 * converts an ActionScript Date instance to a String formatted in ISO 8601 format
		 * @param date to convert
		 * @return a string in ISO 8601 format
		 * */
		public static function toISO8601(date : Date) : String
		{
			return formatter.format(date);
		}


		private static const formatter : DateTimeFormatter = new DateTimeFormatter();


		// static initialization block
		{
			formatter.dateTimePattern = "yyyy-MM-dd'T'HH:mm:ss";
		}
	}
}
