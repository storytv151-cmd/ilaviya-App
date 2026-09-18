package io.flutter.plugins.googlemobileadsexample

import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.NativeAdFactory
import com.example.my_flutter_app.R

class JobStyleNativeAdFactory(private val layoutInflater: LayoutInflater) : NativeAdFactory {

    companion object {
        private const val DEFAULT_HEADLINE_COLOR = "#1e3a8a"
        private const val DEFAULT_BODY_COLOR = "#475569"
        private const val DEFAULT_BUTTON_BG_COLOR = "#059669"
        private const val DEFAULT_BUTTON_TEXT_COLOR = "#FFFFFF"
    }

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val fallbackAdView = layoutInflater.inflate(R.layout.native_ad_job_style, null, false) as NativeAdView
        try {
            android.util.Log.d("JobStyleNativeAdFactory", "Creating native ad view")
            android.util.Log.d("JobStyleNativeAdFactory", "Headline: ${nativeAd.headline}")
            android.util.Log.d("JobStyleNativeAdFactory", "CTA: ${nativeAd.callToAction}")
            android.util.Log.d("JobStyleNativeAdFactory", "Custom options: $customOptions")

            val adView = layoutInflater.inflate(R.layout.native_ad_job_style, null, false) as NativeAdView

            adView.layoutParams = android.view.ViewGroup.LayoutParams(
                android.view.ViewGroup.LayoutParams.MATCH_PARENT,
                android.view.ViewGroup.LayoutParams.MATCH_PARENT
            )

            val density = adView.context.resources.displayMetrics.density
            val cardBgColor = customOptions?.get("cardBackgroundColor") as? String ?: "#FFFFFF"

            try {
                val cardDrawable = GradientDrawable()
                cardDrawable.shape = GradientDrawable.RECTANGLE
                cardDrawable.cornerRadius = 0f
                cardDrawable.setColor(Color.parseColor(cardBgColor))
                cardDrawable.setStroke((1.2f * density).toInt(), Color.parseColor(cardBgColor))
                adView.background = cardDrawable
            } catch (e: Exception) {
                // Fallback on error
            }

            // Register views
            adView.headlineView = adView.findViewById(R.id.primary)
            adView.bodyView = adView.findViewById(R.id.body)
            adView.iconView = adView.findViewById(R.id.ad_app_icon)
            adView.callToActionView = adView.findViewById(R.id.cta)

            // --- Headline ---
            val headlineView = adView.headlineView as? TextView
            if (headlineView != null) {
                headlineView.text = nativeAd.headline
                headlineView.visibility = View.VISIBLE
            }

            // --- Body / Advertiser fallback ---
            val bodyView = adView.bodyView as? TextView
            val subText = nativeAd.advertiser ?: nativeAd.body
            if (bodyView != null) {
                if (subText == null || subText.isEmpty()) {
                    bodyView.visibility = View.GONE
                } else {
                    bodyView.text = subText
                    bodyView.visibility = View.VISIBLE
                }
            }

            // --- Icon ---
            val iconView = adView.iconView as? ImageView
            if (iconView != null) {
                if (nativeAd.icon == null || nativeAd.icon?.drawable == null) {
                    iconView.visibility = View.GONE
                } else {
                    iconView.setImageDrawable(nativeAd.icon!!.drawable)
                    iconView.visibility = View.VISIBLE
                    
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                        iconView.clipToOutline = true
                        iconView.outlineProvider = object : android.view.ViewOutlineProvider() {
                            override fun getOutline(view: android.view.View, outline: android.graphics.Outline) {
                                val radius = 8f * density
                                outline.setRoundRect(0, 0, view.width, view.height, radius)
                            }
                        }
                    }
                }
            }

            // Always apply text styling safely
            if (headlineView != null && bodyView != null) {
                applyCustomTextStyle(headlineView, bodyView, customOptions)
            }

            // --- CTA Button ---
            val ctaButton = adView.callToActionView as? TextView
            if (ctaButton != null) {
                if (nativeAd.callToAction == null) {
                    ctaButton.visibility = View.INVISIBLE
                } else {
                    ctaButton.text = nativeAd.callToAction
                    ctaButton.visibility = View.VISIBLE
                }
                applyCustomButtonStyle(ctaButton, customOptions)
            }

            adView.setNativeAd(nativeAd)
            return adView
        } catch (e: Exception) {
            android.util.Log.e("JobStyleNativeAdFactory", "Error creating native ad: ${e.message}", e)
            return fallbackAdView
        }
    }

    /**
     * Applies custom or default styling to Headline and Body TextViews.
     * Falls back to default colors if customOptions is null or key is missing.
     */
    private fun applyCustomTextStyle(
        headline: TextView,
        body: TextView,
        customOptions: MutableMap<String, Any>?
    ) {
        // Headline color — default if not provided
        val headlineColor = customOptions?.get("headlineTextColor") as? String
            ?: DEFAULT_HEADLINE_COLOR
        try {
            headline.setTextColor(Color.parseColor(headlineColor))
        } catch (e: IllegalArgumentException) {
            headline.setTextColor(Color.parseColor(DEFAULT_HEADLINE_COLOR))
        }

        // Body color — default if not provided
        val bodyColor = customOptions?.get("bodyTextColor") as? String
            ?: DEFAULT_BODY_COLOR
        try {
            body.setTextColor(Color.parseColor(bodyColor))
        } catch (e: IllegalArgumentException) {
            body.setTextColor(Color.parseColor(DEFAULT_BODY_COLOR))
        }
    }

    /**
     * Applies custom or default styling to the CTA button.
     * Falls back to default colors if customOptions is null or key is missing.
     *
     * Supported options:
     * - "buttonBackgroundColor": String hex color e.g. "#1976D2"
     * - "buttonTextColor": String hex color e.g. "#FFFFFF"
     * - "buttonPadding": Double padding in dp e.g. 12.0
     * - "buttonTextSize": Double text size in sp e.g. 16.0
     * - "buttonMinHeight": Double min height in dp e.g. 48.0
     */
    private fun applyCustomButtonStyle(
        button: TextView,
        customOptions: MutableMap<String, Any>?
    ) {
        val density = button.context.resources.displayMetrics.density

        // Button background color — default if not provided
        val bgColor = customOptions?.get("buttonBackgroundColor") as? String
            ?: DEFAULT_BUTTON_BG_COLOR

        // Corner radius — default 8dp
        val cornerRadiusDp = (customOptions?.get("buttonCornerRadius") as? Number)?.toFloat() ?: 8f
        val cornerRadiusPx = cornerRadiusDp * density

        // ✅ GradientDrawable — rounded corners preserve thay
        try {
            val drawable = GradientDrawable()
            drawable.shape = GradientDrawable.RECTANGLE
            drawable.cornerRadius = cornerRadiusPx
            drawable.setColor(Color.parseColor(bgColor))
            button.background = drawable
        } catch (e: IllegalArgumentException) {
            val drawable = GradientDrawable()
            drawable.shape = GradientDrawable.RECTANGLE
            drawable.cornerRadius = cornerRadiusPx
            drawable.setColor(Color.parseColor(DEFAULT_BUTTON_BG_COLOR))
            button.background = drawable
        }

        // Button text color — default if not provided
        val textColor = customOptions?.get("buttonTextColor") as? String
            ?: DEFAULT_BUTTON_TEXT_COLOR
        try {
            button.setTextColor(Color.parseColor(textColor))
        } catch (e: IllegalArgumentException) {
            button.setTextColor(Color.parseColor(DEFAULT_BUTTON_TEXT_COLOR))
        }

        // Button padding (optional)
        val padding = customOptions?.get("buttonPadding") as? Number
        if (padding != null) {
            val paddingPx = (padding.toFloat() * density).toInt()
            button.setPadding(paddingPx, paddingPx, paddingPx, paddingPx)
        }

        // Button text size (optional)
        val textSize = customOptions?.get("buttonTextSize") as? Number
        if (textSize != null) {
            button.textSize = textSize.toFloat()
        }

        // Button min height (optional)
        val minHeight = customOptions?.get("buttonMinHeight") as? Number
        if (minHeight != null) {
            button.minimumHeight = (minHeight.toFloat() * density).toInt()
        }
    }
}