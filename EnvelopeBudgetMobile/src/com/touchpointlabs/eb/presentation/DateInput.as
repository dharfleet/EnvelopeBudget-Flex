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
package com.touchpointlabs.eb.presentation
{
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	import spark.components.TextInput;
	import spark.events.PopUpEvent;
	import spark.formatters.DateTimeFormatter;

	/**
	 * provides a textInput which is read only, when the user clicks, it opens a date chooser which then
	 * places the date into the text input
	 */
	public class DateInput extends TextInput
	{
		protected static var DATE_TIME_PATTERN : String = "dd-MM-yyyy (EEE)";


		public function DateInput()
		{
			super();
			callout = new DateInputCallout();
			dateFormatter = new DateTimeFormatter();
			dateFormatter.dateTimePattern = DATE_TIME_PATTERN;
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			super.editable = false;
		}


		public var userEnteredDate : Date;


		private function onClick(event : MouseEvent) : void
		{
			openCallout();
		}


		private function onFocusIn(event : FocusEvent) : void
		{
			openCallout();
		}


		private function openCallout() : void
		{
			callout.addEventListener(PopUpEvent.CLOSE, closeHandler);
			callout.open(this, true);
		}


		protected function closeHandler(event : PopUpEvent) : void
		{
			callout.removeEventListener(PopUpEvent.CLOSE, closeHandler);
			if (event.commit)
			{
				userEnteredDate = event.data;
				super.text = dateFormatter.format(event.data);
			}
		}


		private var callout : DateInputCallout;
		private var dateFormatter : DateTimeFormatter;

	}
}
