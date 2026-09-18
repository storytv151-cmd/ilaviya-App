package io.flutter.plugins.googlemobileadsexample;

import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.google.android.gms.ads.nativead.MediaView;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;

import java.util.Map;

import io.flutter.plugins.googlemobileads.NativeAdFactory;
import com.example.my_flutter_app.R;

public class NativeAdFactoryExample implements NativeAdFactory {

  private final LayoutInflater layoutInflater;

  // ✅ Default colors — consistent across all pages
  private static final String DEFAULT_HEADLINE_COLOR = "#1e3a8a";
  private static final String DEFAULT_BODY_COLOR = "#475569";
  private static final String DEFAULT_BUTTON_BG_COLOR = "#059669";
  private static final String DEFAULT_BUTTON_TEXT_COLOR = "#FFFFFF";

  public NativeAdFactoryExample(LayoutInflater layoutInflater) {
    this.layoutInflater = layoutInflater;
  }

  @Override
  public NativeAdView createNativeAd(NativeAd nativeAd, Map<String, Object> customOptions) {
    try {
      android.util.Log.d("NativeAdFactoryExample", "Creating native ad view");
      android.util.Log.d("NativeAdFactoryExample", "Headline: " + nativeAd.getHeadline());
      android.util.Log.d("NativeAdFactoryExample", "CTA: " + nativeAd.getCallToAction());
      android.util.Log.d("NativeAdFactoryExample", "Custom options: " + customOptions);

      final NativeAdView adView = (NativeAdView) layoutInflater.inflate(R.layout.my_native_ad, null);

      adView.setLayoutParams(new android.view.ViewGroup.LayoutParams(
              android.view.ViewGroup.LayoutParams.MATCH_PARENT,
              android.view.ViewGroup.LayoutParams.MATCH_PARENT));

      // Register all views
      adView.setMediaView((MediaView) adView.findViewById(R.id.ad_media));
      adView.setHeadlineView(adView.findViewById(R.id.ad_headline));
      adView.setBodyView(adView.findViewById(R.id.ad_body));
      adView.setCallToActionView(adView.findViewById(R.id.ad_call_to_action));
      adView.setIconView(adView.findViewById(R.id.ad_app_icon));
      adView.setPriceView(adView.findViewById(R.id.ad_price));
      adView.setStarRatingView(adView.findViewById(R.id.ad_stars));
      adView.setStoreView(adView.findViewById(R.id.ad_store));
      adView.setAdvertiserView(adView.findViewById(R.id.ad_advertiser));

      // --- Headline ---
      TextView headlineView = (TextView) adView.getHeadlineView();
      if (headlineView != null) {
        headlineView.setText(nativeAd.getHeadline());
        headlineView.setVisibility(View.VISIBLE);
      }

      // --- Media ---
      MediaView mediaView = adView.getMediaView();
      if (mediaView != null && nativeAd.getMediaContent() != null) {
        mediaView.setMediaContent(nativeAd.getMediaContent());
      }

      // --- Body ---
      TextView bodyView = (TextView) adView.getBodyView();
      if (bodyView != null) {
        if (nativeAd.getBody() == null) {
          bodyView.setVisibility(View.INVISIBLE);
        } else {
          bodyView.setVisibility(View.VISIBLE);
          bodyView.setText(nativeAd.getBody());
        }
      }

      // Always apply text styling safely
      applyCustomTextStyle(headlineView, bodyView, customOptions);

      // --- CTA Button ---
      Button ctaButton = (Button) adView.getCallToActionView();
      if (ctaButton != null) {
        if (nativeAd.getCallToAction() == null) {
          ctaButton.setVisibility(View.INVISIBLE);
        } else {
          ctaButton.setVisibility(View.VISIBLE);
          ctaButton.setText(nativeAd.getCallToAction());
        }
        applyCustomButtonStyle(ctaButton, customOptions);
      }

      // --- Icon ---
      ImageView iconView = (ImageView) adView.getIconView();
      if (iconView != null) {
        if (nativeAd.getIcon() == null || nativeAd.getIcon().getDrawable() == null) {
          iconView.setVisibility(View.INVISIBLE);
        } else {
          iconView.setImageDrawable(nativeAd.getIcon().getDrawable());
          iconView.setVisibility(View.VISIBLE);
        }
      }

      // --- Price ---
      TextView priceView = (TextView) adView.getPriceView();
      if (priceView != null) {
        if (nativeAd.getPrice() == null) {
          priceView.setVisibility(View.INVISIBLE);
        } else {
          priceView.setVisibility(View.VISIBLE);
          priceView.setText(nativeAd.getPrice());
        }
      }

      // --- Store ---
      TextView storeView = (TextView) adView.getStoreView();
      if (storeView != null) {
        if (nativeAd.getStore() == null) {
          storeView.setVisibility(View.INVISIBLE);
        } else {
          storeView.setVisibility(View.VISIBLE);
          storeView.setText(nativeAd.getStore());
        }
      }

      // --- Star Rating ---
      RatingBar ratingBar = (RatingBar) adView.getStarRatingView();
      if (ratingBar != null) {
        if (nativeAd.getStarRating() == null) {
          ratingBar.setVisibility(View.INVISIBLE);
        } else {
          ratingBar.setRating(nativeAd.getStarRating().floatValue());
          ratingBar.setVisibility(View.VISIBLE);
        }
      }

      // --- Advertiser ---
      TextView advertiserView = (TextView) adView.getAdvertiserView();
      if (advertiserView != null) {
        if (nativeAd.getAdvertiser() == null) {
          advertiserView.setVisibility(View.INVISIBLE);
        } else {
          advertiserView.setVisibility(View.VISIBLE);
          advertiserView.setText(nativeAd.getAdvertiser());
        }
      }

      adView.setNativeAd(nativeAd);
      return adView;
    } catch (Exception e) {
      android.util.Log.e("NativeAdFactoryExample", "Error creating native ad: " + e.getMessage(), e);
      return (NativeAdView) layoutInflater.inflate(R.layout.my_native_ad, null);
    }
  }

  /**
   * Applies custom or default styling to Headline and Body TextViews.
   * Falls back to default colors if customOptions is null or key is missing.
   */
  private void applyCustomTextStyle(
          TextView headline,
          TextView body,
          Map<String, Object> customOptions
  ) {
    // Headline color — default if not provided
    String headlineColor = DEFAULT_HEADLINE_COLOR;
    if (customOptions != null && customOptions.containsKey("headlineTextColor")) {
      Object val = customOptions.get("headlineTextColor");
      if (val instanceof String) headlineColor = (String) val;
    }
    try {
      headline.setTextColor(Color.parseColor(headlineColor));
    } catch (IllegalArgumentException e) {
      headline.setTextColor(Color.parseColor(DEFAULT_HEADLINE_COLOR));
    }

    // Body color — default if not provided
    String bodyColor = DEFAULT_BODY_COLOR;
    if (customOptions != null && customOptions.containsKey("bodyTextColor")) {
      Object val = customOptions.get("bodyTextColor");
      if (val instanceof String) bodyColor = (String) val;
    }
    try {
      body.setTextColor(Color.parseColor(bodyColor));
    } catch (IllegalArgumentException e) {
      body.setTextColor(Color.parseColor(DEFAULT_BODY_COLOR));
    }
  }

  /**
   * Applies custom or default styling to the CTA Button.
   * Uses GradientDrawable to preserve rounded corners.
   *
   * Supported options:
   * - "buttonBackgroundColor": String hex color e.g. "#1976D2"
   * - "buttonTextColor": String hex color e.g. "#FFFFFF"
   * - "buttonCornerRadius": Double corner radius in dp e.g. 8.0
   * - "buttonTextSize": Double text size in sp e.g. 16.0
   * - "buttonMinHeight": Double min height in dp e.g. 48.0
   */
  private void applyCustomButtonStyle(
          Button button,
          Map<String, Object> customOptions
  ) {
    float density = button.getContext().getResources().getDisplayMetrics().density;

    // Button background color — default if not provided
    String bgColor = DEFAULT_BUTTON_BG_COLOR;
    if (customOptions != null && customOptions.containsKey("buttonBackgroundColor")) {
      Object val = customOptions.get("buttonBackgroundColor");
      if (val instanceof String) bgColor = (String) val;
    }

    // Corner radius — default 8dp
    float cornerRadiusDp = 8f;
    if (customOptions != null && customOptions.containsKey("buttonCornerRadius")) {
      Object val = customOptions.get("buttonCornerRadius");
      if (val instanceof Number) cornerRadiusDp = ((Number) val).floatValue();
    }
    float cornerRadiusPx = cornerRadiusDp * density;

    // ✅ GradientDrawable — rounded corners preserve thay
    try {
      GradientDrawable drawable = new GradientDrawable();
      drawable.setShape(GradientDrawable.RECTANGLE);
      drawable.setCornerRadius(cornerRadiusPx);
      drawable.setColor(Color.parseColor(bgColor));
      button.setBackground(drawable);
    } catch (IllegalArgumentException e) {
      GradientDrawable drawable = new GradientDrawable();
      drawable.setShape(GradientDrawable.RECTANGLE);
      drawable.setCornerRadius(cornerRadiusPx);
      drawable.setColor(Color.parseColor(DEFAULT_BUTTON_BG_COLOR));
      button.setBackground(drawable);
    }

    // Button text color — default if not provided
    String textColor = DEFAULT_BUTTON_TEXT_COLOR;
    if (customOptions != null && customOptions.containsKey("buttonTextColor")) {
      Object val = customOptions.get("buttonTextColor");
      if (val instanceof String) textColor = (String) val;
    }
    try {
      button.setTextColor(Color.parseColor(textColor));
    } catch (IllegalArgumentException e) {
      button.setTextColor(Color.parseColor(DEFAULT_BUTTON_TEXT_COLOR));
    }

    // Button text size (optional)
    if (customOptions != null && customOptions.containsKey("buttonTextSize")) {
      Object val = customOptions.get("buttonTextSize");
      if (val instanceof Number) {
        button.setTextSize(((Number) val).floatValue());
      }
    }

    // Button min height (optional)
    if (customOptions != null && customOptions.containsKey("buttonMinHeight")) {
      Object val = customOptions.get("buttonMinHeight");
      if (val instanceof Number) {
        int minHeightPx = (int) (((Number) val).floatValue() * density);
        button.setMinHeight(minHeightPx);
      }
    }
  }
}