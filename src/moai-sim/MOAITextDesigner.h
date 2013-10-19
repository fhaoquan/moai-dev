// Copyright (c) 2010-2011 Zipline Games, Inc. All Rights Reserved.
// http://getmoai.com

#ifndef	MOAITEXTDESIGNER_H
#define	MOAITEXTDESIGNER_H

class MOAITextBox;
class MOAITextStyle;
class MOAITextStyleSpan;

//================================================================//
// MOAITextDesigner
//================================================================//
class MOAITextDesigner {
private:
	
	//----------------------------------------------------------------//
	// layout state
	
	MOAITextStyleSpan*	mStyleSpan;
	MOAITextStyle*		mStyle;
	u32					mSpanIdx;
	
	int					mIdx;
	int					mPrevIdx;
	int					mNextPageIdx;
	
	cc8*				mStr;
	
	MOAIGlyphSet*		mDeck;
	float				mDeckScale;
	
	int					mLineIdx;
	u32					mLineSpriteID;
	u32					mLineSize;
	float				mLineAscent;
	ZLRect				mLineRect;
	
	int					mTokenIdx;
	u32					mTokenSpriteID;
	u32					mTokenSize;
	float				mTokenAscent;
	ZLRect				mTokenRect;
	
	ZLVec2D				mPen;
	MOAIGlyph*			mPrevGlyph;
	bool				mMore;
	
	//----------------------------------------------------------------//
	// layout settings
	
	ZLVec2D				mLoc;
	
	float				mWidth;
	float				mHeight;
	
	bool				mLimitWidth;
	bool				mLimitHeight;
	
	u32					mHAlign;
	u32					mVAlign;
	
	u32					mWordBreak;
	
	float				mGlyphScale;
	
	u32					mTotalCurves;
	MOAIAnimCurve**		mCurves;
	
	// get rid of
	MOAITextBox*		mTextBox;
	
	//----------------------------------------------------------------//
	void				AcceptLine				();
	void				AcceptToken				();
	void				Align					();
	u32					NextChar				();

public:

	enum {
		LEFT_JUSTIFY,
		CENTER_JUSTIFY,
		RIGHT_JUSTIFY,
	};

	enum {
		WORD_BREAK_NONE,
		WORD_BREAK_CHAR,
	};

	GET_SET ( ZLVec2D&, Loc, mLoc )
	
	GET_SET ( float, Width, mWidth )
	GET_SET ( float, Height, mHeight )
	
	GET_SET ( bool, LimitWidth, mLimitWidth )
	GET_SET ( bool, LimitHeight, mLimitHeight )
	
	GET_SET ( u32, HAlign, mHAlign )
	GET_SET ( u32, VAlign, mVAlign )
	
	GET_SET ( float, GlyphScale, mGlyphScale )

	//----------------------------------------------------------------//
	void			BuildLayout				();
	void			Init					( MOAITextBox& textBox );
					MOAITextDesigner		();
	virtual			~MOAITextDesigner		();
	void			SetCurves				( MOAIAnimCurve** curves, u32 totalCurves );
};

#endif
