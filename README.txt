YQL CURRENCY CONVERTER
----------------------

How To Run:
	Adding/Removing Currencies from Favorites List:
		- Select the "+" icon on the top right corner of the screen.
		- Users will be brought to a screen containing a list of all ISO4217 currencies.
		- Tap on a currency that does not have a checkmark, to signify that you want to add it to your Favorites.
		- Tap on a currency with a checkmark, to signify that you want to remove from your Favorites List.
		- Press the "Save" button on the top right corner of the screen, to save the selected currencies to your Favorites List.

	Perform a Currency Conversion
		- Select the currency that you would like to convert from by using the left picker view to select the currency.
		- Select the currency that you would like to convert to by using the right picker view to select the currency.
		- Once both currencies have been chose, insert an amount to convert by typing it in the text-field provided.
		- Press the "Convert" button to convert the given amount from the currency selected on the right, to the currency selected on the left.
		- The new currency value will be displayed in a label below the text-field.

Implementation:
	- Auto-Layout: Constraints, for better portrait and landscape interface
	- Refresh Exchange Rates in Favorites List once the Expiration has occured: every 60 seconds (Exchange Rates that have been stored longer than this will be considered stale)
	- Asynchrounous Query Handling using NSURLSESSION
	- Favorite Currencies, Exchange Rates, and ISO4217 Currency List are saved using NSCoding library

Models:
	- ExchangeRate
		- This model stores properties and methods with regard to the exchange rates that were queried from YQL.
		- It stores the exchange rate information such as home and foreign currency.
		- By storing the home and foreign currency along with the actual exchange rate, we are able to flip the exchange rate incase the user decides to reverse the query between home and foreign currency.
	- ISO4217Currency
		- This model stores properties and methods with regard to a specific currency participating in ISO4217.
		- Only currencies that that have been favorited witll be instantiated with this model.
		- Every new instance of ISO4217Currency is a singleton.
	- Data
		- This model is responsible for loading and saving information to/from the disk.
		- It incorporates the NSCoding methods to save and load data.
		- It stores information in mutable arrays that can be loaded and saved to/from the disk.
